from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from rag_chain import DiabetIQRAG
# import uvicorn

app = FastAPI()

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize RAG model
# rag_model = DiabetIQRAG()

class QuestionRequest(BaseModel):
    question: str

class AnswerResponse(BaseModel):
    answer: str

@app.get("/")
def read_root():
    return {"message": "DiabetIQ API is running"}







# @app.post("/ask", response_model=AnswerResponse)
# async def ask_question(request: QuestionRequest):
#     try:
#         answer = rag_model.get_response(request.question)
#         return {"answer": answer}
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=str(e))

# # if __name__ == "__main__":
# #     uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)