# Build stage
FROM python:3.11-slim AS builder
WORKDIR /app

COPY app/requirements.txt .
RUN pip install --user -r requirements.txt

# Runtime stage
FROM python:3.11-slim

RUN useradd -m apprunner

WORKDIR /app
COPY --from=builder /root/.local /home/apprunner/.local
COPY app/ .

RUN chown -R apprunner:apprunner /home/apprunner /app
USER apprunner

ENV PATH=/home/apprunner/.local/bin:$PATH

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
