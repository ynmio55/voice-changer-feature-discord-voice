# เริ่มใช้งาน Voice Changer (ภาษาไทย)

## ต้องเตรียมอะไรบ้าง
- Linux, macOS หรือ Windows ที่ใช้ WSL2
- มีการเชื่อมต่ออินเทอร์เน็ต (ครั้งแรกต้องดาวน์โหลดโมเดลและไลบรารี)
- เครื่องที่มี GPU Nvidia จะเร็วขึ้น แต่ไม่มี GPU ก็ใช้ได้

## ขั้นตอน (ทำครั้งเดียวจบ)

```bash
git clone https://github.com/ynmio55/voice-changer-feature-discord-voice
cd voice-changer-feature-discord-voice
bash start_local.sh
```

ครั้งแรกจะใช้เวลานานหลายนาที เพราะต้องติดตั้ง PyTorch และไลบรารีอื่น ๆ ถ้า Linux ขอรหัส sudo ให้ใส่เพื่อติดตั้ง `libportaudio2`

เมื่อขึ้นข้อความ `starting server` ให้เปิด **Chrome** ไปที่ `http://localhost:18888/`

## ครั้งต่อไป
รันแค่คำสั่งเดียว:

```bash
bash start_local.sh
```

## เปลี่ยนพอร์ต
```bash
PORT=9000 bash start_local.sh
```

## ปัญหาที่พบบ่อย
- **เปิดหน้าเว็บไม่ได้** ตรวจว่ามีข้อความ `starting server` ในเทอร์มินัลหรือยัง และใช้ Chrome
- **ดาวน์โหลดโมเดลไม่ได้** ตรวจการเชื่อมต่ออินเทอร์เน็ต หรือเครือข่ายที่บล็อก huggingface.co
- **เสียงไม่ออก/ไม่มีอุปกรณ์เสียง** ตรวจว่าเลือกอุปกรณ์ Input/Output ในหน้าเว็บแล้ว
- **ต้องการติดตั้งใหม่** ลบโฟลเดอร์ `server/.venv` แล้วรัน `bash start_local.sh` อีกครั้ง
