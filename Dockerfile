FROM python:3.9-slim

ENV PYTHONUNBUFFERED 1

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

EXPOSE 8000

ENV DB_USER=
ENV DB_HOST=
ENV DB_NAME=
ENV DB_PASSWORD=
ENV ADMIN_PASSWORD=
CMD alembic upgrade head && uvicorn --host=0.0.0.0 app.main:app
