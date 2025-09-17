# 🌱 PlantFit – Aplikasi Deteksi Jenis Tanah & Rekomendasi Tanaman

**PlantFit** adalah aplikasi mobile berbasis AI yang dirancang untuk mendeteksi jenis tanah secara otomatis menggunakan kamera atau galeri, serta memberikan rekomendasi tanaman yang sesuai. Cocok untuk petani, pelajar, penghobi berkebun, dan siapa pun yang ingin memanfaatkan lahan secara optimal.

---

## 📱 Fitur Utama

🔍 **Deteksi Jenis Tanah Otomatis**  
- Gunakan kamera atau galeri untuk memindai gambar tanah.
- Model CNN (Convolutional Neural Network) menganalisis citra dan menampilkan hasil klasifikasi jenis tanah.

📊 **Rekomendasi Tanaman**  
- Berdasarkan hasil deteksi tanah, pengguna mendapatkan saran tanaman yang cocok untuk ditanam.

📂 **Riwayat Deteksi**  
- Simpan hasil deteksi sebelumnya secara otomatis (baik online maupun offline).
- Sinkronisasi ke Firebase saat koneksi tersedia.

🧠 **AI Berbasis TensorFlow Lite**  
- Model CNN dilatih dengan dataset tanah dan dioptimalkan untuk perangkat mobile menggunakan TFLite.

👥 **Manajemen Profil Pengguna**  
- Pengguna dapat mengatur data pribadi seperti nama, gender, lokasi, dan nomor telepon.

📶 **Dukungan Offline & Sinkronisasi Online**  
- Deteksi tetap bisa dilakukan saat offline, hasil disimpan secara lokal.
- Otomatis tersinkron saat online kembali.

📈 **Dashboard Statistik Deteksi**  
- Tampilkan statistik berupa pie chart distribusi jenis tanah dan daftar 10 hasil terbaru.

🔐 **Autentikasi Firebase**  
- Sistem login aman menggunakan Firebase Authentication.

---

## 🔧 Teknologi yang Digunakan

- **Flutter** – UI dan logika aplikasi
- **TensorFlow Lite** – Model AI klasifikasi tanah
- **Firebase** – Auth, Firestore, Storage
- **Google Cloud Platform** – Cloud Run, Cloud Storage, IAM
  
---

## 📌 Poster

![Poster PlantFit](Poster%20Plantfit.png)
