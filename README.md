# Student Data App

แอพ Flutter สำหรับจัดการข้อมูลนักศึกษา โดยใช้ package `flutter_form_builder` และ `form_builder_validators` เพื่อสร้างฟอร์มที่มีการตรวจสอบข้อมูล (validation) และบันทึกข้อมูลในรูปแบบ JSON ด้วย `shared_preferences` แอพนี้มีสามหน้า: หน้าแรก (เลือกกรอกหรือดูข้อมูล), หน้าฟอร์ม (กรอกข้อมูลนักศึกษา), และหน้ารายชื่อ (แสดงรายชื่อและรายละเอียดจาก JSON)

---

## Table of Contents
- [คุณสมบัติ](#คุณสมบัติ)
- [การติดตั้ง](#การติดตั้ง)
- [การใช้งาน](#การใช้งาน)
- [การเรียนรู้ Package](#การเรียนรู้-package)
- [การแก้ไขปัญหา](#การแก้ไขปัญหา)
- [ตัวอย่าง JSON](#ตัวอย่าง-json)
- [License](#license)

---

## คุณสมบัติ
- **หน้าแรก**: มีปุ่มสองปุ่มสำหรับไปยังหน้าฟอร์มหรือหน้ารายชื่อ
- **หน้าฟอร์ม**:
  - ใช้ทุกฟิลด์จาก `flutter_form_builder` (TextField, CheckboxGroup, Dropdown, RadioGroup, Slider, RangeSlider, Switch, DateTimePicker, DateRangePicker, Field สำหรับ chip)
  - Validate ด้วย `form_builder_validators` (required, minLength, email, numeric, min, max, equalLength)
  - ค่าเริ่มต้นเหมือนจริง (dummy data) เช่น ชื่อ "ชื่อ นามสกุลตัวอย่าง", อีเมล "student@example.com"
  - บันทึกข้อมูลเป็น JSON array ใน `shared_preferences`
  - Slider สีแดงตามคำขอ
- **หน้ารายชื่อ**:
  - ดึง JSON จาก `shared_preferences`
  - แสดงรายชื่อนักศึกษาใน ListView
  - แสดงรายละเอียดใน Dialog แบบตาราง key-value

---

## การติดตั้ง
1. **ติดตั้ง Flutter**:
   - ดาวน์โหลด Flutter SDK จาก https://flutter.dev
   - ตั้งค่า environment ตาม https://flutter.dev/docs/get-started/install
2. **โคลน Repository**:
   ```bash
   git clone <repository-url>
   cd student_app
