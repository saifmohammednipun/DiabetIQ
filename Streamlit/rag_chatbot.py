import os
from dotenv import load_dotenv
import streamlit as st
from langchain import hub
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import PyPDFLoader
from langchain_community.vectorstores import Chroma
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_ollama import OllamaLLM
from langchain_core.documents import Document
from langchain_core.prompts import PromptTemplate

# --- Environment Setup ---
load_dotenv()
langchain_api_key = os.getenv('LANGCHAIN_API_KEY')
huggingface_api_key = os.getenv('HUGGINGFACE_API_KEY')
os.environ['LANGCHAIN_TRACING_V2'] = 'true'
os.environ['LANGCHAIN_API_KEY'] = langchain_api_key
os.environ['HUGGINGFACE_API_KEY'] = huggingface_api_key

# Define PDF file paths (adjust paths as necessary for deployment)
pdf_files = [
    r"D:\diabetIQ\LLM\PDFs\BES-COVID-Pract-Recomnd-06-June-Final-Copy.pdf",
    r"D:\diabetIQ\LLM\PDFs\BES-Ramadan-Guideline-2020-min.pdf",
    r"D:\diabetIQ\LLM\PDFs\Diabetes_Care_BADAS_guideline2019-3.pdf",
    r"D:\diabetIQ\LLM\PDFs\Insulin-Guideline-min.pdf"
]

# --- Data Loading and Processing ---
@st.cache_resource
def load_and_process_pdfs(_file_paths):
    """Loads and processes PDF documents."""
    all_docs = []
    for pdf_path in _file_paths:
        try:
            file_name = os.path.basename(pdf_path)
            loader = PyPDFLoader(pdf_path)
            pages = loader.load_and_split()
            for page_doc in pages:
                page_doc.metadata['source'] = file_name
            all_docs.extend(pages)
        except Exception as e:
            st.error(f"Error loading {pdf_path}: {e}")
    return all_docs

@st.cache_resource
def split_documents(_documents):
    """Splits documents into chunks."""
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=1000,
        chunk_overlap=200,
        separators=["\n\n", "\n", ". ", ", ", " ", ""],
        length_function=len,
    )
    chunks = text_splitter.split_documents(_documents)
    return chunks

# --- Embedding and Vector Store ---
@st.cache_resource
def create_vector_store(_chunks):
    """Creates and persists a Chroma vector store."""
    embedding_model = HuggingFaceEmbeddings(model_name="intfloat/e5-small-v2")
    persist_directory = "./chroma_db_diabetiq"
    if not os.path.exists(persist_directory):
        with st.spinner("Creating vector store..."):
            vectorstore = Chroma.from_documents(
                documents=_chunks,
                embedding=embedding_model,
                persist_directory=persist_directory
            )
            vectorstore.persist()
            st.success("Vector store created and saved.")
    else:
        st.info("Loading existing vector store...")
        vectorstore = Chroma(persist_directory=persist_directory, embedding_function=embedding_model)
        st.success("Vector store loaded.")
    return vectorstore

# --- RAG Chain ---
def format_docs_with_metadata(docs):
    """Formats retrieved documents including source and page."""
    formatted_strings = []
    for i, doc in enumerate(docs):
        metadata_str = f"Source: {doc.metadata.get('source', 'N/A')}, Page: {doc.metadata.get('page', 'N/A')}"
        content_str = doc.page_content.replace('\n', ' ').strip()
        formatted_strings.append(f"{i+1}. [{metadata_str}] {content_str}")
    return "\n\n".join(formatted_strings)

@st.cache_resource
def setup_rag_chain(_vectorstore):
    """Sets up the RAG chain."""
    retriever = _vectorstore.as_retriever(search_kwargs={"k": 5})
    llm = OllamaLLM(model="mistral")  # Ensure Ollama is running with the model pulled

    prompt_template = """
    You are DiabetIQ, an AI assistant specializing in diabetes management for patients in Bangladesh, based *strictly* on the provided context documents (diabetes guidelines and textbooks).

    Context Documents:
    {context}

    Based *only* on the information in the numbered context documents above, answer the following question.
    Be concise but specific. If the context discusses strategies for managing occasional intake of high-sugar foods (like sweets), explain those strategies clearly and actionably. Mention portion control, timing relative to meals, carbohydrate counting/exchange, and the role of sugar substitutes if discussed in the context.
    Consider general dietary principles relevant to Bangladesh if mentioned in the context.
    Do *not* add information or recommendations *not* found in the context documents.
    If the context strictly advises against all sweets with no exceptions or strategies mentioned, state that clearly.
    Always conclude your response by strongly advising the user to consult a healthcare professional or registered dietitian for personalized medical advice tailored to their specific situation.

    Question: {question}

    Answer:
    """

    prompt = PromptTemplate.from_template(prompt_template)

    rag_chain = (
        {"context": retriever | format_docs_with_metadata, "question": RunnablePassthrough()}
        | prompt
        | llm
        | StrOutputParser()
    )
    return rag_chain

# --- Streamlit Application ---
st.set_page_config(page_title="DiabetIQ", page_icon=":hospital:")

st.title("DiabetIQ: Your Diabetes Management Assistant")
st.markdown("Hello! I am DiabetIQ, an AI assistant here to help you understand diabetes management based on official guidelines for patients in Bangladesh.")
st.markdown("Please note: **I am an AI and cannot provide medical advice. Always consult a healthcare professional for personalized guidance.**")

# --- Data Loading and Processing ---
with st.spinner("Loading and processing documents..."):
    all_docs = load_and_process_pdfs(pdf_files)
    if not all_docs:
        st.error("Failed to load any documents. Please check file paths and permissions.")
        st.stop()
    chunks = split_documents(all_docs)
    if not chunks:
        st.error("Failed to create document chunks. Please check document content.")
        st.stop()

# --- Embedding and Vector Store ---
vectorstore = create_vector_store(chunks)

# --- Setup RAG Chain ---
rag_chain = setup_rag_chain(vectorstore)

# --- Chat Interface ---
if "messages" not in st.session_state:
    st.session_state.messages = []

# Display chat messages from history
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

# Handle new user input
if prompt := st.chat_input("Ask a question about diabetes management (e.g., 'Can I eat sweets?'):"):
    st.chat_message("user").markdown(prompt)
    st.session_state.messages.append({"role": "user", "content": prompt})

    with st.spinner("Thinking..."):
        try:
            response = rag_chain.invoke(prompt)
            with st.chat_message("assistant"):
                st.markdown(response)
            st.session_state.messages.append({"role": "assistant", "content": response})
        except Exception as e:
            error_msg = f"An error occurred: {e}. Please ensure Ollama is running and the 'mistral' model is available."
            st.error(error_msg)
            st.session_state.messages.append({"role": "assistant", "content": error_msg})
