# LAMP Server Installation Script

Skrip ini memungkinkan Anda untuk menginstal dan mengelola server LAMP (Linux, Apache, MySQL, PHP) dengan mudah, termasuk instalasi phpMyAdmin. Skrip ini juga menyediakan opsi untuk memulihkan cadangan dan menginstal domain baru.

## Daftar Isi

- [Fitur](#fitur)
- [Prasyarat](#prasyarat)
- [Cara Instalasi](#cara-instalasi)
- [Cara Penggunaan](#cara-penggunaan)
- [Catatan](#catatan)

## Fitur

- Memperbarui sistem
- Menginstal Apache, MySQL, dan PHP (versi 7.4 & 8.1)
- Menginstal phpMyAdmin
- Memulihkan cadangan file dan database
- Menginstal domain baru

## Prasyarat

- Ubuntu 20.04 LTS atau versi yang lebih baru
- Akses root atau sudo

## Cara Instalasi

1. **Clone Repositori**

   Pertama, clone repositori ini ke server Anda:

   ```bash
   git clone https://github.com/username/lamp-server-scripts.git
   cd lamp-server-scripts


2. **Beri Izin Eksekusi pada Skrip**

   Pastikan skrip `lamp_menu.sh` dapat dieksekusi:

   ```bash
   chmod +x lamp_menu.sh
   ```

3. **Jalankan Skrip**

   Untuk menjalankan skrip dan menggunakan menu interaktif:

   ```bash
   ./lamp_menu.sh
   ```

## Cara Penggunaan

Setelah menjalankan skrip, Anda akan melihat menu utama dengan opsi berikut:

1. **Perbarui Sistem**: Memperbarui paket sistem.
2. **Instal Apache**: Menginstal dan mengonfigurasi server web Apache.
3. **Instal MySQL**: Menginstal dan mengonfigurasi server database MySQL.
4. **Instal PHP (7.4 & 8.1)**: Menginstal PHP versi 7.4 dan 8.1 serta modul terkait.
5. **Instal phpMyAdmin**: Menginstal phpMyAdmin dan mengonfigurasinya.
6. **Pulihkan Cadangan**: Memulihkan file website dan database dari cadangan.
7. **Instal Domain**: Mengonfigurasi virtual host untuk domain baru.
8. **Keluar**: Keluar dari skrip.

Ikuti petunjuk di layar untuk memilih opsi yang sesuai dengan kebutuhan Anda.

## Catatan

- Pastikan Anda mengganti placeholder seperti `/path/to/your/backup`, `nama_database_anda`, `user_database_anda`, dan `password_database_anda` dengan informasi yang sesuai.
- Jika Anda mengalami masalah saat menggunakan skrip, pastikan semua prasyarat telah dipenuhi dan periksa log kesalahan untuk informasi lebih lanjut.

Jika Anda memiliki pertanyaan atau masalah, silakan buka [isu](https://github.com/asepsupriatna90/lamp-server-scripts/issues) di GitHub untuk bantuan.

```
