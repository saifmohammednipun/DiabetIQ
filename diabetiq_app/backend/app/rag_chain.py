# import os
# from dotenv import load_dotenv
# from langchain.text_splitter import RecursiveCharacterTextSplitter
# from langchain_community.document_loaders import PyPDFLoader
# from langchain_community.vectorstores import Chroma
# from langchain_core.output_parsers import StrOutputParser
# from langchain_core.runnables import RunnablePassthrough
# from langchain_huggingface import HuggingFaceEmbeddings
# from langchain_ollama import OllamaLLM
# from langchain_core.prompts import PromptTemplate

# load_dotenv()

# class DiabetIQRAG:
#     def __init__(self):
#         self.pdf_files = [
#             os.path.join("PDFs", "BES-COVID-Pract-Recomnd-06-June-Final-Copy.pdf"),
#             os.path.join("PDFs", "BES-Ramadan-Guideline-2020-min.pdf"),
#             os.path.join("PDFs", "Diabetes_Care_BADAS_guideline2019-3.pdf"),
#             os.path.join("PDFs", "Insulin-Guideline-min.pdf")
#         ]
#         self.vectorstore = self._initialize_vectorstore()
#         self.rag_chain = self._setup_rag_chain()

#     def _load_and_process_pdfs(self):
#         """Loads and processes PDF documents."""
#         all_docs = []
#         for pdf_path in self.pdf_files:
#             try:
#                 file_name = os.path.basename(pdf_path)
#                 loader = PyPDFLoader(pdf_path)
#                 pages = loader.load_and_split()
#                 for page_doc in pages:
#                     page_doc.metadata['source'] = file_name
#                 all_docs.extend(pages)
#             except Exception as e:
#                 print(f"Error loading {pdf_path}: {e}")
#         return all_docs

#     def _split_documents(self, documents):
#         """Splits documents into chunks."""
#         text_splitter = RecursiveCharacterTextSplitter(
#             chunk_size=1000,
#             chunk_overlap=200,
#             separators=["\n\n", "\n", ". ", ", ", " ", ""],
#             length_function=len,
#         )
#         return text_splitter.split_documents(documents)

#     def _format_docs_with_metadata(self, docs):
#         """Formats retrieved documents including source and page."""
#         formatted_strings = []
#         for i, doc in enumerate(docs):
#             metadata_str = f"Source: {doc.metadata.get('source', 'N/A')}, Page: {doc.metadata.get('page', 'N/A')}"
#             content_str = doc.page_content.replace('\n', ' ').strip()
#             formatted_strings.append(f"{i+1}. [{metadata_str}] {content_str}")
#         return "\n\n".join(formatted_strings)

#     def _initialize_vectorstore(self):
#         """Creates and persists a Chroma vector store."""
#         embedding_model = HuggingFaceEmbeddings(model_name="intfloat/e5-small-v2")
#         persist_directory = "chroma_db_diabetiq"
        
#         if not os.path.exists(persist_directory):
#             print("Creating vector store...")
#             all_docs = self._load_and_process_pdfs()
#             chunks = self._split_documents(all_docs)
#             vectorstore = Chroma.from_documents(
#                 documents=chunks,
#                 embedding=embedding_model,
#                 persist_directory=persist_directory
#             )
#             vectorstore.persist()
#             print("Vector store created and saved.")
#         else:
#             print("Loading existing vector store...")
#             vectorstore = Chroma(persist_directory=persist_directory, embedding_function=embedding_model)
#             print("Vector store loaded.")
#         return vectorstore

#     def _setup_rag_chain(self):
#         """Sets up the RAG chain."""
#         retriever = self.vectorstore.as_retriever(search_kwargs={"k": 5})
#         llm = OllamaLLM(model="mistral")

#         prompt_template = """
#         You are DiabetIQ, an AI assistant specializing in diabetes management for patients in Bangladesh, based *strictly* on the provided context documents (diabetes guidelines and textbooks).

#         Context Documents:
#         {context}

#         Based *only* on the information in the numbered context documents above, answer the following question.
#         Be concise but specific. If the context discusses strategies for managing occasional intake of high-sugar foods (like sweets), explain those strategies clearly and actionably. Mention portion control, timing relative to meals, carbohydrate counting/exchange, and the role of sugar substitutes if discussed in the context.
#         Consider general dietary principles relevant to Bangladesh if mentioned in the context.
#         Do *not* add information or recommendations *not* found in the context documents.
#         If the context strictly advises against all sweets with no exceptions or strategies mentioned, state that clearly.
#         Always conclude your response by strongly advising the user to consult a healthcare professional or registered dietitian for personalized medical advice tailored to their specific situation.

#         Question: {question}

#         Answer:
#         """

#         prompt = PromptTemplate.from_template(prompt_template)

#         rag_chain = (
#             {"context": retriever | self._format_docs_with_metadata, "question": RunnablePassthrough()}
#             | prompt
#             | llm
#             | StrOutputParser()
#         )
#         return rag_chain

#     def get_response(self, question: str):
#         """Get response from RAG chain."""
#         return self.rag_chain.invoke(question)


import os
from dotenv import load_dotenv
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import PyPDFLoader
from langchain_community.vectorstores import Chroma
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_ollama import OllamaLLM
from langchain_core.prompts import PromptTemplate

# --- Environment Setup ---
load_dotenv()
langchain_api_key = os.getenv('LANGCHAIN_API_KEY')
huggingface_api_key = os.getenv('HUGGINGFACE_API_KEY')

os.environ['LANGCHAIN_TRACING_V2'] = 'true'
os.environ['LANGCHAIN_API_KEY'] = langchain_api_key
os.environ['HUGGINGFACE_API_KEY'] = huggingface_api_key

class DiabetIQRAG:
    def __init__(self):
        # --- Define PDF file paths (absolute paths) ---
        self.pdf_files = [
            r"D:\DiabetIQ\diabetiq_app\backend\PDFs\BES-COVID-Pract-Recomnd-06-June-Final-Copy.pdf",
            r"D:\DiabetIQ\diabetiq_app\backend\PDFs\BES-Ramadan-Guideline-2020-min.pdf",
            r"D:\DiabetIQ\diabetiq_app\backend\PDFs\Diabetes_Care_BADAS_guideline2019-3.pdf",
            r"D:\DiabetIQ\diabetiq_app\backend\PDFs\Insulin-Guideline-min.pdf"
        ]
        self.all_docs = self._load_and_process_pdfs()
        self.chunks = self._split_documents(self.all_docs)
        self.vectorstore = self._initialize_vectorstore(self.chunks)
        self.rag_chain = self._setup_rag_chain(self.vectorstore)

    def _load_and_process_pdfs(self):
        """Loads and processes PDF documents."""
        all_docs = []
        for pdf_path in self.pdf_files:
            try:
                file_name = os.path.basename(pdf_path)
                loader = PyPDFLoader(pdf_path)
                pages = loader.load_and_split()
                for page_doc in pages:
                    page_doc.metadata['source'] = file_name
                all_docs.extend(pages)
            except Exception as e:
                print(f"Error loading {pdf_path}: {e}")
        return all_docs

    def _split_documents(self, documents):
        """Splits documents into chunks."""
        text_splitter = RecursiveCharacterTextSplitter(
            chunk_size=1000,
            chunk_overlap=200,
            separators=["\n\n", "\n", ". ", ", ", " ", ""],
            length_function=len,
        )
        return text_splitter.split_documents(documents)

    def _initialize_vectorstore(self, chunks):
        """Creates and persists a Chroma vector store."""
        embedding_model = HuggingFaceEmbeddings(model_name="intfloat/e5-small-v2")
        persist_directory = "chroma_db_diabetiq"

        if not os.path.exists(persist_directory):
            print("Creating vector store...")
            vectorstore = Chroma.from_documents(
                documents=chunks,
                embedding=embedding_model,
                persist_directory=persist_directory
            )
            vectorstore.persist()
            print("Vector store created and saved.")
        else:
            print("Loading existing vector store...")
            vectorstore = Chroma(persist_directory=persist_directory, embedding_function=embedding_model)
            print("Vector store loaded.")
        return vectorstore

    def _format_docs_with_metadata(self, docs):
        """Formats retrieved documents including source and page."""
        formatted_strings = []
        for i, doc in enumerate(docs):
            metadata_str = f"Source: {doc.metadata.get('source', 'N/A')}, Page: {doc.metadata.get('page', 'N/A')}"
            content_str = doc.page_content.replace('\n', ' ').strip()
            formatted_strings.append(f"{i+1}. [{metadata_str}] {content_str}")
        return "\n\n".join(formatted_strings)

    def _setup_rag_chain(self, vectorstore):
        """Sets up the RAG chain."""
        retriever = vectorstore.as_retriever(search_kwargs={"k": 5})
        llm = OllamaLLM(model="mistral")  # Ensure Ollama is running

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
            {"context": retriever | self._format_docs_with_metadata, "question": RunnablePassthrough()}
            | prompt
            | llm
            | StrOutputParser()
        )
        return rag_chain

    def ask(self, question):
        """Public method to ask a question to DiabetIQ."""
        try:
            return self.rag_chain.invoke(question)
        except Exception as e:
            return f"An error occurred while answering: {e}. Please ensure Ollama is running and the 'mistral' model is available."
