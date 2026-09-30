# ---------- Stage 1: builder ----------
FROM python:3.12-slim AS builder

WORKDIR /app
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---------- Stage 2: final runtime ----------
FROM python:3.12-slim

RUN useradd --create-home appuser
WORKDIR /app

COPY --from=builder /opt/venv /opt/venv
COPY app.py .

ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1

USER appuser
EXPOSE 5000

CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
