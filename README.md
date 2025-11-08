# Tiraz — AI-Powered Custom Tailoring Platform

[![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-green.svg)](https://fastapi.tiangolo.com/)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-blue.svg)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Tiraz is a modern AI-powered tailoring platform built with FastAPI, Flutter, and PostgreSQL. The platform enables custom tailoring services with AI-driven body measurements, order management, and mobile-first user experience.

## 🏗️ Architecture

The Tiraz MVP platform consists of three main components:

### Backend API (FastAPI)
- **Technology**: Python FastAPI
- **Port**: 8000
- **Features**:
  - RESTful API endpoints
  - User authentication and authorization
  - Order and measurement management
  - Integration with AI models
  - PostgreSQL database integration

### Mobile Application (Flutter)
- **Technology**: Flutter (Dart)
- **Platforms**: iOS and Android
- **Features**:
  - User-friendly mobile interface
  - Camera integration for measurements
  - Order tracking
  - Design catalog browsing
  - Real-time updates

### Database (PostgreSQL)
- **Technology**: PostgreSQL 15
- **Port**: 5432
- **Features**:
  - Relational data storage
  - User data management
  - Order and measurement records
  - Transaction support

## 🚀 Quick Start

### Prerequisites

Before you begin, ensure you have the following installed:
- **Python 3.8+**: Backend development
- **Docker & Docker Compose**: Container orchestration
- **Flutter SDK**: Mobile app development
- **Git**: Version control

### Option 1: Docker Setup (Recommended)

The easiest way to get started is using Docker Compose:

```bash
# 1. Clone the repository
git clone https://github.com/OsmanMohamad249/Tiraz.git
cd Tiraz

# 2. Start all services
docker-compose up -d

# 3. Verify services are running
docker-compose ps

# You should see:
# - backend (port 8000) - FastAPI backend
# - postgres (port 5432) - PostgreSQL database
```

**Service URLs:**
- Backend API: http://localhost:8000
- API Documentation: http://localhost:8000/docs (Swagger UI)
- PostgreSQL: localhost:5432

### Option 2: Local Development Setup

#### Backend Setup (FastAPI)

```bash
# Navigate to backend directory
cd backend

# Create and activate virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run the development server
uvicorn main:app --reload --port 8000

# Backend will be available at http://localhost:8000
# API docs at http://localhost:8000/docs
```

#### Mobile App Setup (Flutter)

```bash
# Navigate to mobile app directory
cd mobile-app

# Install Flutter dependencies
flutter pub get

# Run on connected device or emulator
flutter run

# Or build for specific platform
flutter build apk    # For Android
flutter build ios    # For iOS (macOS only)
```

### Stop Services

```bash
# Stop Docker services
docker-compose down

# Stop and remove volumes (WARNING: deletes all data)
docker-compose down -v
```

## 📋 API Endpoints

### Health Check
- `GET /health` - Service health status

### User Management (Coming Soon)
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/login` - User login
- `GET /api/v1/users/me` - Get current user profile

### Measurements (Coming Soon)
- `POST /api/v1/measurements` - Create new measurement
- `GET /api/v1/measurements/{id}` - Get measurement details
- `GET /api/v1/measurements` - List user measurements

### Orders (Coming Soon)
- `POST /api/v1/orders` - Create new order
- `GET /api/v1/orders/{id}` - Get order details
- `GET /api/v1/orders` - List user orders

### Designs (Coming Soon)
- `GET /api/v1/designs` - Browse available designs
- `GET /api/v1/designs/{id}` - Get design details

For complete API documentation, visit http://localhost:8000/docs when the backend is running.

## 📁 Project Structure

```
Tiraz/
├── backend/                    # FastAPI backend application
│   ├── main.py                # Application entry point
│   ├── requirements.txt       # Python dependencies
│   ├── Dockerfile             # Backend Docker configuration
│   └── README.md              # Backend documentation
├── mobile-app/                # Flutter mobile application
│   ├── lib/                   # Flutter source code
│   │   └── main.dart         # App entry point
│   ├── pubspec.yaml          # Flutter dependencies
│   ├── Dockerfile            # Mobile app Docker config
│   └── android/              # Android-specific files
│   └── ios/                  # iOS-specific files
├── ai-models/                 # AI/ML services (future)
│   └── README.md             # AI models documentation
├── docs/                      # Project documentation
│   ├── SETUP.md              # Setup guide
│   ├── DEVELOPMENT.md        # Development workflow
│   └── API.md                # API documentation
├── docker-compose.yml         # Docker orchestration
├── .gitignore                # Git ignore rules
└── README.md                 # This file
```

## 🔧 Development

### Backend Development

The FastAPI backend uses:
- **FastAPI**: Modern Python web framework
- **Uvicorn**: ASGI server
- **PostgreSQL**: Database (via psycopg2 or SQLAlchemy)
- **Pydantic**: Data validation

To add new features:
1. Create route handlers in `backend/`
2. Define Pydantic models for request/response validation
3. Add database models and migrations
4. Update API documentation

### Mobile App Development

The Flutter app provides:
- Cross-platform mobile experience (iOS & Android)
- Material Design UI components
- State management
- API integration with backend

To add new features:
1. Create new screens in `mobile-app/lib/screens/`
2. Add widgets in `mobile-app/lib/widgets/`
3. Implement API calls in `mobile-app/lib/services/`
4. Test on both iOS and Android

### Database Management

PostgreSQL is used for all persistent data:
- User accounts and authentication
- Measurements and body data
- Orders and transactions
- Design catalog

Database connection details:
- **Host**: localhost (or `postgres` in Docker)
- **Port**: 5432
- **Database**: tiraz_db
- **User**: tiraz
- **Password**: tiraz_password (change in production!)

## 🧪 Testing

### Backend Tests

```bash
cd backend
pytest                          # Run all tests
pytest -v                       # Verbose output
pytest --cov=.                  # With coverage report
```

### Mobile App Tests

```bash
cd mobile-app
flutter test                    # Run all tests
flutter test --coverage         # With coverage
```

## 🐛 Troubleshooting

### Backend Issues

**Problem**: Port 8000 already in use
```bash
# Solution: Stop the process using the port
lsof -ti:8000 | xargs kill  # macOS/Linux
# Or change the port
uvicorn main:app --reload --port 8001
```

**Problem**: Database connection failed
```bash
# Solution: Ensure PostgreSQL is running
docker-compose ps
docker-compose restart postgres
```

### Mobile App Issues

**Problem**: Flutter dependencies not found
```bash
# Solution: Clean and reinstall
flutter clean
flutter pub get
```

**Problem**: Build fails on iOS
```bash
# Solution: Update pods
cd ios
pod install
cd ..
flutter run
```

**Problem**: Build fails on Android
```bash
# Solution: Clean gradle
cd android
./gradlew clean
cd ..
flutter run
```

### Docker Issues

**Problem**: Containers won't start
```bash
# Solution: Check logs and rebuild
docker-compose logs backend
docker-compose down
docker-compose up --build
```

## 📚 Documentation

For more detailed information, please refer to:

- **[Setup Guide](docs/SETUP.md)**: Detailed installation and configuration
- **[Development Guide](docs/DEVELOPMENT.md)**: Development workflow and standards
- **[API Documentation](docs/API.md)**: Complete API reference
- **[Backend README](backend/README.md)**: Backend-specific documentation
- **[Mobile App README](mobile-app/README.md)**: Mobile app documentation

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes following our coding standards
4. Test your changes thoroughly
5. Commit your changes (`git commit -m 'feat: add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

Please read [DEVELOPMENT.md](docs/DEVELOPMENT.md) for detailed contribution guidelines.

## 🔐 Security

For production deployment:
- Change all default passwords
- Use environment variables for sensitive data
- Enable HTTPS/SSL
- Configure proper CORS settings
- Use production-grade database credentials
- Implement rate limiting
- Enable authentication on all protected endpoints

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

**Tiraz Development Team**
- GitHub: [@OsmanMohamad249](https://github.com/OsmanMohamad249)

## 🌟 Acknowledgments

- FastAPI for the excellent Python web framework
- Flutter team for the amazing cross-platform framework
- PostgreSQL community for the reliable database

---

**Current Status**: Boilerplate setup complete. Ready for Sprint 1 development.

Made with ❤️ for modern tailoring solutions
