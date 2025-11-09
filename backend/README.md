```markdown
# Backend (FastAPI) - Tiraz

This folder contains the FastAPI backend application for Tiraz with secure configuration and modular structure.

## Quick Start (Local Development)

### Prerequisites
- Python 3.8+
- PostgreSQL database (or use Docker Compose)

### Setup Steps

1. **Create and activate virtual environment:**
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```

2. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Configure environment variables:**
   ```bash
   cp .env.example .env
   # Edit .env and set required values (especially DATABASE_URL and SECRET_KEY)
   ```

   **IMPORTANT**: Generate a strong SECRET_KEY:
   ```bash
   python -c "import secrets; print(secrets.token_urlsafe(32))"
   ```

4. **Run database migrations:**
   ```bash
   alembic upgrade head
   ```

5. **Run the application:**
   ```bash
   uvicorn main:app --reload --port 8000
   ```

## Docker (Local Development)

Using Docker Compose (recommended):
```bash
# From project root
docker-compose up backend
```

Building manually:
```bash
docker build -t tiraz-backend:dev -f Dockerfile .
docker run --rm -p 8000:8000 \
  -e DATABASE_URL=your_db_url \
  -e SECRET_KEY=your_secret_key \
  tiraz-backend:dev
```

## Configuration

All configuration is managed through environment variables using Pydantic BaseSettings.

### Required Environment Variables
- `DATABASE_URL`: PostgreSQL connection string (e.g., `postgresql://user:pass@host:port/db`)
- `SECRET_KEY`: Strong secret key for JWT signing (min 32 characters)

### Optional Environment Variables
- `CORS_ORIGINS`: Comma-separated list of allowed CORS origins (default: localhost)
- `ACCESS_TOKEN_EXPIRE_MINUTES`: JWT token expiration (default: 30)
- `AI_SERVICE_URL`: URL for AI model service (default: http://ai-models:8000)

See `.env.example` for complete configuration template.

## API Endpoints

### Health Check
- `GET /health` - Basic health check

### Authentication (API v1)
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login and get JWT token

### Users (API v1)
- `GET /api/v1/users/me` - Get current user info (requires authentication)

### Measurements (API v1)
- `POST /api/v1/measurements` - Create measurement (requires authentication)
- `GET /api/v1/measurements` - List measurements (requires authentication)

## Testing

Run tests with pytest:
```bash
pytest tests/ -v
```

For tests with coverage:
```bash
pytest tests/ --cov=. --cov-report=html
```

## Security Features

✅ **Secure Configuration**
- Required environment variables with validation
- No hardcoded secrets in code
- Pydantic BaseSettings for type safety

✅ **Authentication & Authorization**
- JWT token-based authentication
- Password hashing with bcrypt
- Role-based access control (RBAC)

✅ **CORS Protection**
- Configurable allowed origins
- No wildcard origins by default

✅ **Input Validation**
- Pydantic schemas for all endpoints
- Password length and complexity validation
- Email validation

## Project Structure

```
backend/
├── api/
│   └── v1/
│       ├── endpoints/    # API route handlers
│       │   ├── auth.py
│       │   ├── users.py
│       │   └── measurements.py
│       └── api.py        # API router aggregation
├── core/
│   ├── config.py         # Configuration (Pydantic BaseSettings)
│   ├── security.py       # Auth utilities (password hashing, JWT)
│   ├── database.py       # Database session management
│   └── deps.py           # FastAPI dependencies
├── models/               # SQLAlchemy models
│   ├── user.py
│   ├── roles.py
│   └── measurement.py
├── schemas/              # Pydantic schemas
│   ├── user.py
│   └── measurement.py
├── services/             # Business logic layer
├── tests/                # Test suite
│   ├── test_auth.py
│   ├── test_rbac.py
│   └── test_measurements.py
├── alembic/              # Database migrations
├── main.py               # FastAPI app initialization
└── requirements.txt
```

## Next Steps

- [ ] Add more comprehensive API tests
- [ ] Implement refresh tokens
- [ ] Add rate limiting
- [ ] Implement logging and monitoring
- [ ] Add API documentation with examples
```
