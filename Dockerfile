# ---- base image ----
FROM python:3.9-slim

# ---- working directory ----
WORKDIR /app

# ---- copy requirements and install ----
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# ---- copy app source ----
COPY . .

# ---- run app ----
CMD ["python", "app.py"]
