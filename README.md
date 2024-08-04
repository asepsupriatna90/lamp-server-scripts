# LAMP Server Scripts

Skrip ini menyediakan alat interaktif untuk menginstal dan mengelola server LAMP (Linux, Apache, MySQL, PHP) pada Ubuntu 20.04 LTS. Skrip ini mendukung instalasi PHP multi-versi (7.4 dan 8.1) dan menawarkan fitur pemulihan cadangan serta pengaturan domain virtual host.

## Fitur

- Perbarui sistem
- Instal Apache
- Instal MySQL
- Instal PHP (versi 7.4 dan 8.1)
- Pulihkan cadangan file website dan database
- Instal domain baru dengan virtual host

## Prasyarat

- Ubuntu 20.04 LTS
- Akses root atau sudo

## Instalasi

1. **Clone repositori:**

    ```bash
    git clone https://github.com/asepsupriatna90/lamp-server-scripts.git
    cd lamp-server-scripts
    ```

2. **Buat skrip dapat dieksekusi:**

    ```bash
    chmod +x lamp_menu.sh
    ```

## Penggunaan

Jalankan skrip `lamp_menu.sh` untuk menampilkan menu interaktif:

```bash
./lamp_menu.sh
