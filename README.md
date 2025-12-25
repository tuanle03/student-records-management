# Student Records Management (https://cnmeow.site/)

A Ruby on Rails web application for managing student information and academic records (students, classes/courses, enrollments, grades, and reporting).
Built with Rails (Ruby) and server-rendered views (Haml), with Docker support for easy local development and deployment.

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Screenshots](#screenshots)
- [Getting Started (Local)](#getting-started-local)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
  - [Run the application](#run-the-application)
  - [Run tests](#run-tests)
- [Configuration](#configuration)
- [Docker (Recommended)](#docker-recommended)
  - [Run with Docker Compose](#run-with-docker-compose)
  - [Database setup in Docker](#database-setup-in-docker)
- [Deployment](#deployment)
  - [Production checklist](#production-checklist)
  - [Deploy with Docker](#deploy-with-docker)
  - [Deploy with Kamal (optional)](#deploy-with-kamal-optional)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

---

## Features

> Adjust this list to match your actual implemented modules.

- Student management (create/update/search student profiles)
- Course/Class management (subjects, classes, schedules)
- Enrollment management (assign students to classes/courses)
- Grades & transcripts (record grades, view academic history)
- Basic reporting (filter/export lists, summary views)
- Authentication & authorization (admin/staff roles) _(if applicable)_
- Responsive UI pages rendered on the server (Haml templates)

---

## Tech Stack

- **Backend:** Ruby on Rails
- **Views:** Haml + HTML
- **Database:** PostgreSQL
- **Containerization:** Docker, Docker Compose

---

## Screenshots
<img width="1866" height="923" alt="image" src="https://github.com/user-attachments/assets/3139a8f0-a4d6-4519-9f05-54dde7059a5c" />

### Dashboard

<img width="1911" height="879" alt="image" src="https://github.com/user-attachments/assets/614a8a1e-806b-4baf-add0-b2f405d86bb8" />

<img width="1912" height="761" alt="image" src="https://github.com/user-attachments/assets/bdcea5bf-8cf3-40c5-8e11-521722eb0771" />

<img width="1900" height="886" alt="image" src="https://github.com/user-attachments/assets/5aa067dc-4d38-47fc-8910-f33af75fae91" />

### Student List

<img width="1903" height="933" alt="image" src="https://github.com/user-attachments/assets/976ade1a-1986-41c2-82b5-261b015362f5" />

### Student Detail / Transcript

<img width="1906" height="913" alt="image" src="https://github.com/user-attachments/assets/e8b43329-eee8-49a2-9141-356b0b433b71" />

<img width="1903" height="834" alt="image" src="https://github.com/user-attachments/assets/712d58c6-7dbd-474d-b167-ff37f7002230" />

<img width="1902" height="827" alt="image" src="https://github.com/user-attachments/assets/b84d1f45-5a59-496d-9931-02e21f95de68" />



---

## Getting Started (Local)

### Prerequisites

- Ruby (see `.ruby-version`)
- Bundler
- PostgreSQL
- Node.js (if your asset pipeline requires it)

### Setup

```bash
git clone https://github.com/tuanle03/student-records-management.git
cd student-records-management

bundle install
```

### Run the application

1. Setup database:

```bash
bin/rails db:create
bin/rails db:migrate
# optional
bin/rails db:seed
```

2. Start the server:

```bash
bin/rails server
```

Then open: `http://localhost:3000`

### Run tests

```bash
bin/rails test
```

---

## Configuration

Common environment variables (names may vary based on your `config/database.yml` and credentials setup):

- `RAILS_ENV` (e.g. `development`, `test`, `production`)
- `DATABASE_URL` or separate DB vars such as `DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`
- `RAILS_MASTER_KEY` (required for production when using encrypted credentials)

If you use Rails encrypted credentials, do **not** commit `config/master.key` to the repository.

---

## Docker (Recommended)

This repository already includes `Dockerfile` and `docker-compose.yml`.

### Run with Docker Compose

```bash
docker compose up --build
```

By default (per `docker-compose.yml`), the app is exposed at:

- `http://localhost:8000`

### Database setup in Docker

In a new terminal:

```bash
docker compose exec web bin/rails db:create db:migrate
# optional
docker compose exec web bin/rails db:seed
```

To stop:

```bash
docker compose down
```

---

## Deployment

### Production checklist

- Set **secure** values for:
  - `RAILS_MASTER_KEY`
  - DB credentials
  - Rails secret key base (typically managed via Rails credentials)
- Enable HTTPS (via reverse proxy such as Nginx/Caddy/Traefik)
- Configure persistent storage if you use Active Storage
- Configure logging and monitoring
- Run database migrations during deploy

### Deploy with Docker

High-level approach:

1. Build the image
2. Run the container with production environment variables
3. Ensure PostgreSQL is reachable (managed DB or containerized DB)
4. Run `bin/rails db:migrate` on release

Example (illustrative only):

```bash
docker build -t student-records-management:latest .
docker run -p 80:80 \
  -e RAILS_ENV=production \
  -e RAILS_MASTER_KEY="YOUR_MASTER_KEY" \
  -e DB_HOST="YOUR_DB_HOST" \
  -e DB_NAME="YOUR_DB_NAME" \
  -e DB_USER="YOUR_DB_USER" \
  -e DB_PASSWORD="YOUR_DB_PASSWORD" \
  student-records-management:latest
```

### Deploy with Kamal (optional)

This repo contains a `.kamal/` directory, which suggests Kamal deployment may be used.

- Configure your servers and registry in Kamal config files
- Ensure secrets are provided securely (master key, DB password, etc.)
- Deploy using your preferred Kamal workflow

> TODO: Add exact Kamal commands and configuration notes once your `.kamal` setup is finalized.

---

## Project Structure

Typical Rails structure:

- `app/` - controllers, models, views (Haml templates)
- `config/` - routes, environment config, initializers
- `db/` - migrations and seeds
- `test/` - test suite
- `Dockerfile`, `docker-compose.yml` - container setup

---

## Contributing

Contributions are welcome.

1. Fork the repo
2. Create a feature branch: `git checkout -b feature/my-change`
3. Commit changes: `git commit -m "Add my change"`
4. Push branch: `git push origin feature/my-change`
5. Open a Pull Request

---

## License

Add your license information here.

> TODO: Choose a license (e.g. MIT) and add a `LICENSE` file.
