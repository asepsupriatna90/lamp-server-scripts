# Lamp Server Scripts

Skrip ini menyediakan alat otomatis untuk mengelola server LAMP (Linux, Apache, MySQL, PHP). Dengan skrip ini, Anda dapat melakukan berbagai tugas administratif seperti menginstal perangkat lunak, membuat cadangan, memulihkan data, dan mengonfigurasi domain serta HTTPS.

## Fitur

- **Perbarui Sistem:** Memperbarui dan meng-upgrade sistem operasi.
- **Instal Apache:** Menginstal dan mengonfigurasi Apache.
- **Instal MySQL:** Menginstal dan mengamankan MySQL.
- **Instal PHP:** Menginstal PHP 7.4 dan 8.1.
- **Instal phpMyAdmin:** Menginstal dan mengamankan phpMyAdmin.
- **Backup Data:** Membuat cadangan file website dan database.
- **Pulihkan Cadangan:** Memulihkan file website dan database dari cadangan.
- **Instal Domain:** Mengonfigurasi virtual host untuk domain baru.
- **Setup HTTPS:** Mengonfigurasi HTTPS menggunakan Certbot.
- **Ganti Domain:** Mengganti konfigurasi domain lama dengan yang baru.
- **Ganti Database, Username, dan Password:** Mengganti database, pengguna, dan password.

## Prasyarat

- VPS atau server berbasis Linux.
- Hak akses root atau sudo.
- Koneksi internet.

## Instalasi

1. **Clone Repository:**

   ```bash
   git clone https://github.com/username/lamp-server-scripts.git
   cd lamp-server-scripts
   ```

2. **Instal Dialog:**

   Jika `dialog` belum terpasang, instal dengan:

   ```bash
   sudo apt update
   sudo apt install dialog -y
   ```

3. **Beri Hak Eksekusi pada Skrip:**

   ```bash
   sudo chmod +x admin_setup.sh
   ```

4. **Pindahkan Skrip ke Direktori Eksekusi:**

   ```bash
   sudo mv admin_setup.sh /usr/local/bin/
   ```

5. **Edit `.bashrc` untuk Menjalankan Skrip saat Login:**

   ```bash
   sudo nano /root/.bashrc
   ```

   Tambahkan baris berikut di akhir file:

   ```bash
   # Menjalankan menu admin setelah login
   /usr/local/bin/admin_setup.sh
   ```

6. **Simpan dan Muat Ulang `.bashrc`:**

   ```bash
   source /root/.bashrc
   ```

## Penggunaan

Setelah melakukan langkah-langkah di atas, setiap kali Anda login ke VPS, menu interaktif akan muncul, memungkinkan Anda untuk memilih berbagai opsi untuk mengelola server.

### Opsi Menu

1. **Perbarui Sistem**: Memperbarui dan meng-upgrade sistem operasi.
2. **Instal Apache**: Menginstal dan mengonfigurasi Apache.
3. **Instal MySQL**: Menginstal dan mengamankan MySQL.
4. **Instal PHP (7.4 & 8.1)**: Menginstal PHP 7.4 dan 8.1.
5. **Instal phpMyAdmin**: Menginstal dan mengamankan phpMyAdmin.
6. **Backup Data**: Membuat cadangan file website dan database.
7. **Pulihkan Cadangan**: Memulihkan file website dan database dari cadangan.
8. **Instal Domain**: Mengonfigurasi virtual host untuk domain baru.
9. **Setup HTTPS**: Mengonfigurasi HTTPS menggunakan Certbot.
10. **Ganti Domain**: Mengganti konfigurasi domain lama dengan yang baru.
11. **Ganti Database, Username, dan Password**: Mengganti database, pengguna, dan password.
12. **Keluar**: Keluar dari menu.

## Kontribusi

Jika Anda memiliki saran atau perbaikan untuk skrip ini, jangan ragu untuk mengajukan pull request atau membuka issue di repository.

## Lisensi

Skrip ini dilisensikan di bawah [MIT License](LICENSE).

```
