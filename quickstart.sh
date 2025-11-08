#!/bin/bash
# Quick start script for Tiraz demo
# برنامج البدء السريع للنسخة التجريبية من طراز

set -e

echo "============================================================"
echo "🚀 TIRAZ QUICK START - البدء السريع لطراز"
echo "============================================================"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8 or higher."
    echo "❌ بايثون 3 غير مثبت. يرجى تثبيت بايثون 3.8 أو أحدث."
    exit 1
fi

echo "✅ Python found: $(python3 --version)"

# Check if requirements are installed
echo ""
echo "📦 Checking dependencies... / التحقق من المتطلبات..."
if ! python3 -c "import flask" 2>/dev/null; then
    echo "📥 Installing dependencies... / تثبيت المتطلبات..."
    pip install -r requirements.txt
else
    echo "✅ Dependencies already installed / المتطلبات مثبتة بالفعل"
fi

# Create .env if it doesn't exist
if [ ! -f .env ]; then
    echo ""
    echo "📝 Creating .env file... / إنشاء ملف البيئة..."
    cp .env.example .env
    echo "✅ .env file created / تم إنشاء ملف البيئة"
fi

# Run demo setup
echo ""
echo "🎭 Setting up demo data... / إعداد البيانات التجريبية..."
echo "y" | python3 demo.py

echo ""
echo "============================================================"
echo "✨ Setup complete! / اكتمل الإعداد!"
echo "============================================================"
echo ""
echo "🌐 Starting the application... / تشغيل التطبيق..."
echo ""
echo "   Application will be available at:"
echo "   التطبيق سيكون متاحاً على:"
echo ""
echo "   👉 http://localhost:5000"
echo ""
echo "   Press Ctrl+C to stop the server"
echo "   اضغط Ctrl+C لإيقاف الخادم"
echo ""
echo "============================================================"

# Start the application
python3 run.py
