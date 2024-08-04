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
