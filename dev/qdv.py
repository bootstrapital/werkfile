# Step 0 - Imports
import json 

import requests
import numpy as np

from ollama import chat, embed

# Step 1

# Get job description using Jina Reader API
job_url = 'https://careers.datadoghq.com/detail/6351811/?gh_jid=6351811' # As text input
r_job = requests.get(f'https://r.jina.ai/{job_url}')
job_description = r_job.text

# Step 2
# Parse job description using NuExtract via Ollama

job_template = '''{
  "company_name": "string",
  "company_description": "string",
  "job_title": "string",
  "overview": "string",
  "responsibilities": ["string"],
  "requirements": ["string"],
  "location": {
    "city": "string",
    "is_remote": "boolean"
  },
  "salary_range": {
    "min": "float",
    "max": "float"
  }
}'''

# docs: https://ollama.com/library/nuextract
job_prompt = f'''
### Template: 
{job_template}

### Text:
{job_description}
'''

job_extract = chat(
    model='nuextract', 
    messages=[
        {
            'role': 'user',
            'content': job_prompt
        }
    ],
    options={'temperature': 0},
)
print(job_extract.message.content)

# Step 3

# Load resume from JSON file
# resume = json.load(open('resume.json'))

# # Step 4

# # Flatten achievments by role

# queries = []
# for company in resume['companies']:
#     for role in company['roles']:
#         for achievement in role['achievements']:
#             query = f'{company["name"]} - {role["title"]} - {achievement["title"]}: {achievement["details"]}'
#             queries.append(query)

# Step 5
# Use Qwen to get embeddings

# def get_embedding(text, model="qwen2.5:1.5b"):
#     url = f"http://localhost:11434/api/v1/embeddings"  # Replace with your Ollama API endpoint if different
#     headers = {"Content-Type": "application/json"}
#     payload = {
#         "model": model,
#         "prompt": text,
#     }
#     response = requests.post(url, headers=headers, json=payload)
#     if response.status_code == 200:
#         return response.json()["embedding"]
#     else:
#         raise Exception(f"Error from Ollama API: {response.text}")

# Fetch embeddings for queries and documents
# query_embeddings = np.array([get_embedding(query) for query in queries])
# document_embeddings = np.array([get_embedding(doc) for doc in documents])

# # Compute scores using cosine similarity or dot product
# scores = query_embeddings @ document_embeddings.T * 100
# print(scores.tolist())
