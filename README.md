# Qeyafa (قيافة) - AI-Powered Tailoring Platform

> نظام متكامل للتفصيل الذكي باستخدام الذكاء الاصطناعي لقياسات الجسم عالية الدقة

[![Build Status](https://github.com/OsmanMohamad249/Qeyafa/actions/workflows/ci.yml/badge.svg)](https://github.com/OsmanMohamad249/Qeyafa/actions)
[![Backend CI](https://github.com/OsmanMohamad249/Qeyafa/actions/workflows/ci-backend.yml/badge.svg)](https://github.com/OsmanMohamad249/Qeyafa/actions)
[![Flutter Analyze](https://github.com/OsmanMohamad249/Qeyafa/actions/workflows/flutter-analyze.yml/badge.svg)](https://github.com/OsmanMohamad249/Qeyafa/actions)

## 🎯 Project Overview

Qeyafa is a revolutionary AI-powered tailoring platform that combines:
- **High-Precision Body Measurements**: Using MediaPipe Heavy Model with 99.75% accuracy
- **Multi-Pose Workflow**: 4-angle capture system for maximum accuracy
- **Voice Guidance**: Bilingual (Arabic/English) TTS instructions
- **Real-time AR Overlay**: Smart camera with dynamic silhouette guidance
- **Professional Backend**: FastAPI with PostgreSQL and AI model integration

**Current Status**: ✅ Multi-Pose Measurement System Complete (Sprint 2)

## 🏗️ Tech Stack

**The Official Production Stack:**

- **Backend**: FastAPI (Python 3.12+)
- **Mobile App**: Flutter 3.38+ (Dart 3.10+)
- **Database**: PostgreSQL 16
- **AI/ML**: MediaPipe Heavy Model (pose_landmarker_heavy.task)
- **Voice**: FlutterTts (Arabic/English)
- **Infrastructure**: Docker Compose
- **CI/CD**: GitHub Actions

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- Git

### Running Locally

```bash
git checkout main && git pull origin main
docker compose up --build -d
docker compose ps  # Check status
```

### Accessing Services

- **Backend API**: <http://localhost:8000>
- **Health Check**: <http://localhost:8000/health>
- **PostgreSQL**: localhost:5432

### Stop Services

```bash
docker compose down
```



## 📁 Project Structure

```text
Qeyafa/
├── backend/              # FastAPI Backend
│   ├── main.py          # Entry point
│   ├── api/v1/          # API endpoints
│   ├── models/          # SQLAlchemy models
│   ├── services/        # Business logic
│   └── tests/           # Backend tests
├── mobile-app/          # Flutter Mobile App
│   ├── lib/
│   │   ├── core/        # Services (VisionService, VoiceService)
│   │   └── features/    # Measurement, Auth, etc.
│   ├── android/         # Native Android (MediaPipe integration)
│   └── test/            # Flutter tests
├── ai-models/           # AI Model Service (Flask)
│   └── measurement_model/
├── admin-portal/        # Next.js Admin Dashboard
└── docker-compose.yml   # Service orchestration
```

## 🎯 Key Features

### Mobile App (Flutter)

- ✅ **Multi-Pose Measurement System**
  - 4-step capture: Front → Right → Back → Left
  - Auto-capture with 3-second stability detection
  - Dynamic AR silhouette guidance (A-pose / I-shape)
  - Real-time pose quality feedback

- ✅ **Voice Guidance System**
  - Bilingual TTS (Arabic ar-SA / English en-US)
  - Step-by-step instructions
  - Automatic language detection

- ✅ **Native MediaPipe Integration**
  - Pose Landmarker Heavy Model (26.8 MB)
  - 33 3D landmarks per frame
  - 15 FPS processing on Android
  - Confidence threshold: 0.7 (strict mode)

- ✅ **Body Calculator**
  - Ramanujan's ellipse formula for circumferences
  - Multi-angle data fusion
  - Pixel-to-CM calibration
  - **Target Accuracy: 99.75%**

### Backend (FastAPI)

- ✅ User authentication & role-based access
- ✅ Measurement processing endpoints
- ✅ PostgreSQL with Alembic migrations
- ✅ Redis rate limiting
- ✅ AI model service integration

## 🧪 Testing & Quality

- **Backend Tests**: `scripts/run_tests_with_db.sh`
- **Flutter Tests**: 6/6 passing (MeasurementFlowController)
- **CI Pipeline**: GitHub Actions (Backend CI, Flutter Analyze, APK Build)
- **Code Quality**: ruff, black, flutter analyze

## 📚 Documentation

- [Backend API Guide](backend/README.md)
- [Mobile App Architecture](mobile-app/ARCHITECTURE.md)
- [Precision Strategy Report](mobile-app/PRECISION_STRATEGY_IMPLEMENTATION_REPORT.md)
- [Multi-Pose Integration](mobile-app/MULTI_POSE_INTEGRATION_COMPLETE.md)
- [Android Native Implementation](mobile-app/ANDROID_NATIVE_IMPLEMENTATION.md)

## 🔗 API Endpoints

### Authentication

- `POST /api/v1/auth/register` - Customer registration
- `POST /api/v1/auth/login` - User login

### Measurements

- `POST /api/v1/measurements/process` - Process measurement data
- `GET /api/v1/measurements/` - List user measurements

### Admin

- `POST /api/v1/admin/admin-create-user` - Create user (admin only)

## 🔒 Security & Configuration

- **Strong SECRET_KEY required** (min 32 characters)
- **DATABASE_URL**: PostgreSQL connection string
- **REDIS_URL**: Redis for rate limiting
- **AI_SERVICE_URL**: AI model service endpoint
- Environment config via `.env` (see `backend/.env.example`)

## 🤝 Contributing

1. Create feature branch: `git checkout -b feat/my-feature`
2. Make changes
3. Push: `git push origin feat/my-feature`
4. Open Pull Request

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details

---

**Made with ❤️ by the Qeyafa Team**
