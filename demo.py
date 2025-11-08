#!/usr/bin/env python3
"""
Demo script for Tiraz Application
تشغيل تجريبي لتطبيق طراز

This script populates the database with sample data for demonstration purposes.
هذا البرنامج يملأ قاعدة البيانات ببيانات نموذجية لأغراض العرض التجريبي.
"""
import os
import sys
from datetime import datetime, timedelta
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Add the project directory to path
sys.path.insert(0, os.path.dirname(__file__))

from app import create_app, db
from app.models import Item


def clear_database():
    """Clear all existing data from database"""
    print("🗑️  Clearing existing data... / تنظيف البيانات الموجودة...")
    Item.query.delete()
    db.session.commit()
    print("✅ Database cleared / تم تنظيف قاعدة البيانات")


def create_demo_items():
    """Create sample items for demonstration"""
    print("\n📦 Creating demo items... / إنشاء عناصر تجريبية...")
    
    demo_items = [
        {
            'name': 'ثوب رجالي كلاسيكي',
            'description': 'ثوب تقليدي بتصميم عصري، مناسب للمناسبات الرسمية وغير الرسمية. مصنوع من قماش قطني عالي الجودة.',
            'style': 'Traditional'
        },
        {
            'name': 'Classic Men\'s Thobe',
            'description': 'Traditional thobe with modern design, suitable for formal and informal occasions. Made from high-quality cotton fabric.',
            'style': 'Traditional'
        },
        {
            'name': 'قميص رسمي أبيض',
            'description': 'قميص أبيض كلاسيكي مع ياقة إيطالية، مثالي للعمل والمناسبات الرسمية.',
            'style': 'Formal'
        },
        {
            'name': 'White Formal Shirt',
            'description': 'Classic white shirt with Italian collar, perfect for work and formal events.',
            'style': 'Formal'
        },
        {
            'name': 'ثوب صيفي خفيف',
            'description': 'ثوب صيفي مريح مصنوع من قماش خفيف ومسامي، مثالي للطقس الحار.',
            'style': 'Casual'
        },
        {
            'name': 'Summer Light Thobe',
            'description': 'Comfortable summer thobe made from lightweight breathable fabric, ideal for hot weather.',
            'style': 'Casual'
        },
        {
            'name': 'قميص كاجوال منقوش',
            'description': 'قميص منقوش بألوان متناسقة، مريح للاستخدام اليومي والخروجات غير الرسمية.',
            'style': 'Casual'
        },
        {
            'name': 'Casual Patterned Shirt',
            'description': 'Patterned shirt with harmonious colors, comfortable for daily wear and casual outings.',
            'style': 'Casual'
        },
        {
            'name': 'ثوب عيد فاخر',
            'description': 'ثوب فاخر مطرز بتصميم خاص، مثالي للأعياد والمناسبات الخاصة.',
            'style': 'Luxury'
        },
        {
            'name': 'Luxury Eid Thobe',
            'description': 'Luxury embroidered thobe with special design, perfect for Eid and special occasions.',
            'style': 'Luxury'
        },
        {
            'name': 'قميص دينم كاجوال',
            'description': 'قميص دينم عصري بتصميم مريح، مناسب للإطلالات اليومية.',
            'style': 'Modern'
        },
        {
            'name': 'Modern Denim Shirt',
            'description': 'Modern denim shirt with comfortable design, suitable for everyday looks.',
            'style': 'Modern'
        }
    ]
    
    items_created = []
    for i, item_data in enumerate(demo_items):
        # Create items with staggered creation dates for more realistic demo
        item = Item(
            name=item_data['name'],
            description=item_data['description'],
            style=item_data['style']
        )
        # Simulate creation over the past week
        item.created_at = datetime.utcnow() - timedelta(days=6-i//2, hours=i*2)
        db.session.add(item)
        items_created.append(item)
    
    db.session.commit()
    print(f"✅ Created {len(items_created)} demo items / تم إنشاء {len(items_created)} عنصر تجريبي")
    
    return items_created


def display_summary(items):
    """Display summary of created items"""
    print("\n" + "="*60)
    print("📊 DEMO DATA SUMMARY / ملخص البيانات التجريبية")
    print("="*60)
    
    # Group by style
    styles = {}
    for item in items:
        style = item.style or 'Uncategorized'
        if style not in styles:
            styles[style] = []
        styles[style].append(item)
    
    for style, style_items in styles.items():
        print(f"\n{style}: {len(style_items)} items")
        for item in style_items[:2]:  # Show first 2 items per style
            print(f"  - {item.name}")
        if len(style_items) > 2:
            print(f"  ... and {len(style_items) - 2} more")
    
    print("\n" + "="*60)


def main():
    """Main demo setup function"""
    print("="*60)
    print("🎭 TIRAZ APPLICATION DEMO SETUP")
    print("تشغيل تجريبي لتطبيق طراز")
    print("="*60)
    
    # Create Flask app
    config_name = os.environ.get('FLASK_ENV', 'development')
    app = create_app(config_name)
    
    with app.app_context():
        # Check database
        print(f"\n📁 Database: {app.config['SQLALCHEMY_DATABASE_URI']}")
        
        # Clear existing data
        response = input("\n⚠️  Clear existing data? (y/N) / مسح البيانات الموجودة؟ (y/N): ")
        if response.lower() == 'y':
            clear_database()
        else:
            print("Keeping existing data... / الإبقاء على البيانات الموجودة...")
        
        # Create demo items
        items = create_demo_items()
        
        # Display summary
        display_summary(items)
        
        print("\n✨ Demo setup complete! / اكتمل الإعداد التجريبي!")
        print("\n📝 Next steps / الخطوات التالية:")
        print("   1. Run the application: python3 run.py")
        print("   2. Open browser: http://localhost:5000")
        print("   3. Explore the demo data / استكشف البيانات التجريبية")
        print("\n" + "="*60)


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⚠️  Demo setup cancelled / تم إلغاء الإعداد التجريبي")
        sys.exit(0)
    except Exception as e:
        print(f"\n❌ Error: {str(e)}")
        sys.exit(1)
