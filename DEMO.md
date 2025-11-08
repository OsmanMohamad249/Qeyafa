# Tiraz Application - Demo Guide
# دليل التشغيل التجريبي لتطبيق طراز

This guide will help you run a trial/demo version of the Tiraz application with sample data.

هذا الدليل سيساعدك على تشغيل نسخة تجريبية من تطبيق طراز مع بيانات نموذجية.

## 🚀 Quick Start / البدء السريع

### 1. Prerequisites / المتطلبات الأساسية

- Python 3.8 or higher / بايثون 3.8 أو أحدث
- pip (Python package manager) / مدير حزم بايثون

### 2. Setup / الإعداد

```bash
# Clone the repository (if not already done)
# استنساخ المستودع (إذا لم يتم بعد)
git clone https://github.com/OsmanMohamad249/Tiraz.git
cd Tiraz

# Install dependencies
# تثبيت المتطلبات
pip install -r requirements.txt

# Create environment file
# إنشاء ملف البيئة
cp .env.example .env
```

### 3. Run Demo Setup / تشغيل الإعداد التجريبي

The demo script will populate the database with sample items:

```bash
python3 demo.py
```

The script will:
- ✅ Ask if you want to clear existing data / يسأل إذا كنت تريد مسح البيانات الموجودة
- ✅ Create 12 sample items (Thobes, Shirts) / ينشئ 12 عنصر نموذجي (أثواب، قمصان)
- ✅ Organize items by style (Traditional, Formal, Casual, Luxury, Modern) / ينظم العناصر حسب الأسلوب

### 4. Start the Application / تشغيل التطبيق

```bash
python3 run.py
```

The application will start on: **http://localhost:5000**

### 5. Explore the Demo / استكشاف النسخة التجريبية

Open your web browser and visit:

| Page | URL | Description |
|------|-----|-------------|
| Home / الرئيسية | http://localhost:5000/ | Main dashboard with feature overview |
| Items List / قائمة العناصر | http://localhost:5000/items/ | View all demo items |
| Create Item / إنشاء عنصر | http://localhost:5000/items/create | Add new custom items |
| About / حول | http://localhost:5000/about | About the application |

## 📦 Demo Data / البيانات التجريبية

The demo includes sample items in different styles:

### Traditional (تقليدي)
- Classic Men's Thobes / أثواب رجالية كلاسيكية
- Traditional designs with modern touches / تصاميم تقليدية بلمسات عصرية

### Formal (رسمي)
- Formal white shirts / قمصان بيضاء رسمية
- Professional attire / ملابس احترافية

### Casual (كاجوال)
- Summer thobes / أثواب صيفية
- Patterned casual shirts / قمصان منقوشة

### Luxury (فاخر)
- Eid special thobes / أثواب العيد الخاصة
- Premium embroidered designs / تصاميم مطرزة فاخرة

### Modern (عصري)
- Denim shirts / قمصان دينم
- Contemporary designs / تصاميم معاصرة

## 🎯 Demo Features / مميزات النسخة التجريبية

You can test the following features:

### 1. View Items (عرض العناصر)
- Browse all items / تصفح جميع العناصر
- See item details / عرض تفاصيل العنصر
- Bilingual support (Arabic/English) / دعم ثنائي اللغة

### 2. Create Items (إنشاء عناصر)
- Add new custom items / إضافة عناصر جديدة
- Set name, description, and style / تحديد الاسم والوصف والأسلوب
- Form validation / التحقق من صحة النماذج

### 3. Edit Items (تعديل العناصر)
- Update existing items / تحديث العناصر الموجودة
- Modify any field / تعديل أي حقل

### 4. Delete Items (حذف العناصر)
- Remove items from database / حذف العناصر من قاعدة البيانات
- Confirmation required / يتطلب تأكيد

## 🧪 Testing / الاختبار

Run the test suite to verify everything works:

```bash
python3 -m unittest tests.test_app -v
```

All 11 tests should pass:
- ✅ Application exists and runs
- ✅ Home page loads
- ✅ About page loads
- ✅ Items list page loads
- ✅ Create item functionality
- ✅ View item functionality
- ✅ Edit item functionality
- ✅ Delete item functionality
- ✅ Item model works correctly

## 📊 Database / قاعدة البيانات

The demo uses SQLite database:
- Location: `instance/tiraz.db`
- Automatically created on first run / يتم إنشاؤها تلقائياً عند التشغيل الأول
- Can be reset by deleting the file / يمكن إعادة تعيينها بحذف الملف

To reset the database:
```bash
rm -rf instance/tiraz.db
python3 demo.py
```

## 🛠️ Troubleshooting / حل المشاكل

### Port already in use / المنفذ مستخدم بالفعل

If port 5000 is already in use, you can change it in `run.py`:

```python
app.run(host='0.0.0.0', port=5001, debug=debug_mode)
```

### Dependencies not installed / المتطلبات غير مثبتة

Make sure all dependencies are installed:
```bash
pip install -r requirements.txt
```

### Database errors / أخطاء قاعدة البيانات

Delete the database and recreate it:
```bash
rm -rf instance/tiraz.db
python3 demo.py
python3 run.py
```

## 📝 Notes / ملاحظات

- This is a **development demo** / هذه نسخة تطوير تجريبية
- Debug mode is enabled / وضع التصحيح مفعّل
- Not suitable for production / غير مناسبة للإنتاج
- Data is stored locally / البيانات مخزنة محلياً

## 🔗 Next Steps / الخطوات التالية

After exploring the demo, you can:

1. **Customize the application** / تخصيص التطبيق
   - Modify templates in `app/templates/`
   - Update styles in `app/static/css/`
   - Add new features

2. **Connect to production services** / الربط بخدمات الإنتاج
   - See `README.md` for full MVP architecture
   - Integrate AI models from `ai-models/`
   - Connect backend services from `backend/`

3. **Deploy the application** / نشر التطبيق
   - Use Docker Compose (see `docker-compose.yml`)
   - Configure production database
   - Set up proper authentication

## 💡 Demo Scenarios / سيناريوهات تجريبية

Try these workflows:

### Scenario 1: Browse Items
1. Go to Items page / اذهب لصفحة العناصر
2. View different styles / اعرض الأساليب المختلفة
3. Click on an item to see details / انقر على عنصر لرؤية التفاصيل

### Scenario 2: Add Custom Item
1. Click "Add Item" / انقر "إضافة عنصر"
2. Enter item details / أدخل تفاصيل العنصر
3. Submit and view in list / أرسل واعرض في القائمة

### Scenario 3: Edit Existing Item
1. Select an item / اختر عنصراً
2. Click "Edit" / انقر "تعديل"
3. Update information / حدّث المعلومات
4. Save changes / احفظ التغييرات

### Scenario 4: Complete CRUD Flow
1. Create a new item / أنشئ عنصراً جديداً
2. View the item / اعرض العنصر
3. Edit the item / عدّل العنصر
4. Delete the item / احذف العنصر

## 📞 Support / الدعم

For issues or questions:
- Open an issue on GitHub / افتح مشكلة على GitHub
- Check the main README.md / راجع ملف README.md الرئيسي
- Review the documentation in `docs/` / راجع الوثائق في مجلد docs/

---

صُنع بـ ❤️ | Made with ❤️

**Happy Demo-ing! / تجربة سعيدة!** 🎉
