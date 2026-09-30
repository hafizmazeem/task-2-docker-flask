# Task 2: Application Containerization & Asset Optimization

A Flask web app connected to a MySQL database, containerized with a multi-stage Dockerfile and run with Docker Compose.

## Features
- **Multi-stage Dockerfile**: dependencies are installed in a builder stage, and only the virtual environment and app code are copied into a slim final image, which keeps the image small.
- **Secure configuration**: database credentials are read from environment variables. No secrets in the code or in the image.
- **Non-root container**: the app runs as an unprivileged user and is served by gunicorn.
- **Port routing**: Flask is published on host port 5000. MySQL is not published and is only reachable by the web container over the internal Compose network.
- **Healthcheck**: the web container starts only after MySQL is ready.
- **Persistent data**: a named volume keeps the database between restarts.

## Project structure
- `app.py` - Flask application
- `requirements.txt` - Python dependencies
- `Dockerfile` - multi-stage build
- `docker-compose.yml` - web and MySQL services
- `.env.example` - template for required variables
- `.dockerignore` - files excluded from the image
- `.gitignore` - files excluded from git

## Prerequisites
Docker and the Docker Compose plugin.

## How to run

1. Clone the repo:

        git clone https://github.com/hafizmazeem/task-2-docker-flask.git
        cd task-2-docker-flask

2. Create your `.env` from the template and set real passwords:

        cp .env.example .env
        nano .env

3. Build and start:

        docker compose up --build -d

4. Open `http://<host-ip>:5000`. You should see: "Success! Flask successfully connected to MySQL container."

5. Check the image size:

        docker images

## Useful commands

    docker compose ps          # container status
    docker compose logs web    # app logs
    docker compose down        # stop
    docker compose down -v     # stop and delete database volume

## Environment variables

| Variable | Purpose |
|---|---|
| `DB_HOST` | MySQL service name (`mysql`) |
| `DB_USER` | Application database user |
| `DB_PASSWORD` | Application database password |
| `DB_NAME` | Database name |
| `MYSQL_ROOT_PASSWORD` | MySQL root password |

## Notes
- If you change database values in `.env` after the first run, MySQL keeps the old credentials in its volume. Run `docker compose down -v` to reset.
- On a cloud server such as EC2, open port 5000 in the security group to reach the app from a browser.
