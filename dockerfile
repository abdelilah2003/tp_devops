# 1) Base image with Python preinstalled
FROM python:3.11-slim

# 2) Make Python behave well in containers
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# 3) Set a working directory inside the container
WORKDIR /app

# 4) Copy only dependencies file first (better build caching)
COPY requirements.txt .

# 5) Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 6) Copy the rest of your project into the image
COPY . .

# 7) (Optional/Informational) declare the port your app listens on
EXPOSE 5000

# 8) Start the app
#    You can use Python's dev server or a prod server like gunicorn.
#    For now, keep it simple:
CMD ["python", "app.py"]
