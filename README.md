# Nutri App

![Screenshot 1](login.jpg) | ![Screenshot 2](images/regist.jpg) | ![Screenshot 3](images/screenshot3.jpg)
---|---|---
![Screenshot 4](images/screenshot4.jpg) | ![Screenshot 5](images/screenshot5.jpg) | ![Screenshot 6](images/screenshot6.jpg)

Aplikasi Flutter untuk melacak asupan nutrisi harian dengan fitur pencatatan makanan, perhitungan gizi, dan pemantauan target kesehatan.

## Deskripsi

Nutri App membantu pengguna untuk:
- 📝 Mencatat makanan yang dikonsumsi setiap hari
- 🧮 Menghitung nilai gizi secara otomatis
- 📈 Memantau kemajuan nutrisi dengan visualisasi grafis
- 🎯 Menetapkan target personal berdasarkan profil pengguna
- 📅 Menyimpan riwayat nutrisi lengkap

## Fitur Utama
- **Autentikasi Pengguna** 🔐
  - Sistem registrasi dan login aman
  - Integrasi Firebase Authentication
- **AI Nutrition Parser** 🤖
  - Analisis input teks natural (contoh: "200gr nasi + 1 potong ayam")
  - Estimasi nutrisi menggunakan model AI
- **Dashboard Interaktif** 📊
  - Progress bar nutrisi real-time
  - Grafik perkembangan mingguan
- **Database Makanan** 🍎
  - 10,000+ entri makanan
  - Pencarian instan dengan autocomplete

## Cara Menggunakan

### Instalasi
1. Clone repository:
```bash
git clone https://github.com/username/nutriapp.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Tambahkan file konfigurasi Firebase:
```bash
assets/
└── firebase-config.json
```

### Menjalankan Aplikasi
```bash
flutter run --release
```

## Teknologi
- **Frontend**:
  - Flutter 3.13
  - GetX State Management
  - Lottie Animations

- **Backend**:
  - Firebase Firestore
  - Cloud Functions
  - OpenAI Integration

- **Paket Flutter**:
  ```yaml
  dependencies:
    get: ^4.6.6
    firebase_core: ^2.16.0
    syncfusion_flutter_charts: ^23.1.40
    flutter_barcode_scanner: ^3.0.1
  ```

## Struktur Folder
```
lib/
├── app/
│   ├── modules/
│   ├── routes/
│   └── bindings/
├── core/
│   ├── services/
│   └── utils/
├── data/
│   ├── models/
│   └── repositories/
└── widgets/
```

Dikembangkan dengan ❤️ oleh [Nama Anda] | [2024] | [Kontak Email]
