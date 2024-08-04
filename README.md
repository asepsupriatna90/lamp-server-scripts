# LAMP Server Setup Script

Skrip ini membantu Anda menginstal dan mengelola LAMP server (Linux, Apache, MySQL, PHP) di Ubuntu 20.04 LTS. Skrip ini juga mendukung instalasi phpMyAdmin, pemulihan cadangan, dan pengaturan domain virtual.

## Fitur

- Perbarui sistem
- Instal Apache
- Instal MySQL
- Instal PHP (7.4 & 8.1)
- Instal phpMyAdmin
- Pulihkan cadangan website dan database
- Instal domain virtual

## Prasyarat

Pastikan Anda telah menginstal `git` di sistem Anda. Jika belum, instal dengan perintah berikut:

```bash
sudo apt update
sudo apt install git
Cara Menggunakan
Clone Repositori:

Clone repositori ini ke sistem Anda:

bash
Salin kode
git clone https://github.com/username/lamp-server-scripts.git
cd lamp-server-scripts
Buat Skrip Dapat Dieksekusi:

Buat skrip dapat dieksekusi dengan perintah berikut:

bash
Salin kode
chmod +x lamp_menu.sh
Jalankan Skrip:

Jalankan skrip dengan perintah berikut:

bash
Salin kode
./lamp_menu.sh
Ikuti Instruksi di Layar:

Pilih opsi yang diinginkan dari menu interaktif.

Konfigurasi
Ubah nilai variabel berikut dalam skrip lamp_menu.sh sesuai kebutuhan Anda:

bash
Salin kode
BACKUP_DIR="/path/to/your/backup"
WEB_ROOT="/var/www/html"
DB_NAME="nama_database_anda"
DB_USER="user_database_anda"
DB_PASS="password_database_anda"
Lisensi
Proyek ini dilisensikan di bawah lisensi MIT. Lihat berkas LICENSE untuk informasi lebih lanjut.

ruby
Salin kode

### Langkah 3: Menyimpan dan Mengunggah ke GitHub

1. **Inisialisasi Repositori:**

   Pastikan Anda berada di direktori `lamp-server-scripts` dan inisialisasi repositori Git:

   ```bash
   git init
Tambahkan dan Commit Berkas:

Tambahkan berkas lamp_menu.sh dan README.md ke repositori:

bash
Salin kode
git add lamp_menu.sh README.md
git commit -m "Menambahkan skrip instalasi LAMP dan README"
Push ke GitHub:

Hubungkan repositori lokal Anda dengan repositori GitHub dan push perubahan:

bash
Salin kode
git remote add origin https://github.com/asepsupriatna90/lamp-server-scripts.git
git branch -M main
git push -u origin main
