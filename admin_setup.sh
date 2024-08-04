#!/bin/bash

# Definisikan variabel
BACKUP_DIR="/var/backups"
WEB_ROOT="/var/www/html"
DB_NAME="your_db_name"
DB_USER="your_db_user"
DB_PASS="your_db_pass"

# Fungsi untuk memeriksa dan menginstal dialog jika belum terpasang
function install_dialog {
    if ! command -v dialog &> /dev/null; then
        echo "dialog belum terinstal. Menginstal dialog..."
        sudo apt update
        sudo apt install dialog -y
    fi
}

# Fungsi untuk memeriksa dan menginstal Certbot jika belum terpasang
function install_certbot {
    if ! command -v certbot &> /dev/null; then
        echo "Certbot belum terinstal. Menginstal Certbot..."
        sudo apt update
        sudo apt install certbot python3-certbot-apache -y
    fi
}

function update_system {
    echo "Memperbarui sistem..."
    sudo apt update
    sudo apt upgrade -y
}

function install_apache {
    echo "Menginstal Apache..."
    sudo apt install apache2 -y
    sudo systemctl start apache2
    sudo systemctl enable apache2
}

function install_mysql {
    echo "Menginstal MySQL..."
    sudo apt install mysql-server -y
    sudo mysql_secure_installation
}

function install_php {
    echo "Menginstal PHP 7.4..."
    sudo apt install php7.4 php7.4-mysql libapache2-mod-php7.4 -y

    echo "Menginstal PHP 8.1..."
    sudo apt install software-properties-common -y
    sudo add-apt-repository ppa:ondrej/php -y
    sudo apt update
    sudo apt install php8.1 php8.1-mysql libapache2-mod-php8.1 -y
}

function install_phpmyadmin {
    echo "Menginstal phpMyAdmin..."
    sudo apt install phpmyadmin -y

    echo "Mengonfigurasi phpMyAdmin..."
    sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
    sudo systemctl restart apache2

    echo "Mengamankan phpMyAdmin..."
    sudo bash -c "echo 'AuthType Basic' >> /usr/share/phpmyadmin/.htaccess"
    sudo bash -c "echo 'AuthName \"Restricted Files\"' >> /usr/share/phpmyadmin/.htaccess"
    sudo bash -c "echo 'AuthUserFile /etc/phpmyadmin/.htpasswd' >> /usr/share/phpmyadmin/.htaccess"
    sudo bash -c "echo 'Require valid-user' >> /usr/share/phpmyadmin/.htpasswd"
    sudo htpasswd -c /etc/phpmyadmin/.htpasswd admin

    echo "phpMyAdmin berhasil diinstal dan dikonfigurasi!"
}

function backup_data {
    echo "Membuat backup file website..."
    sudo tar -czvf $BACKUP_DIR/web_files_backup.tar.gz $WEB_ROOT

    echo "Membuat backup database..."
    mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/database_backup.sql

    echo "Backup selesai!"
}

function restore_backup {
    FILES=($(ls $BACKUP_DIR))
    FILES+=("Kembali")

    CHOICE=$(dialog --clear --title "Restore Backup" --menu "Pilih file backup untuk dipulihkan" 15 50 4 "${FILES[@]}" 2>&1 >/dev/tty)

    if [ "$CHOICE" == "Kembali" ]; then
        return
    fi

    BACKUP_FILE="$BACKUP_DIR/$CHOICE"
    EXT="${BACKUP_FILE##*.}"

    case $EXT in
        tar.gz)
            TEMP_DIR=$(mktemp -d)
            tar -xzvf "$BACKUP_FILE" -C "$TEMP_DIR"

            echo "Memulihkan file website..."
            sudo rsync -av --delete "$TEMP_DIR/web_files/" "$WEB_ROOT/"

            echo "Memulihkan database..."
            if [[ -f "$TEMP_DIR/database_backup.sql" ]]; then
                mysql -u $DB_USER -p$DB_PASS $DB_NAME < "$TEMP_DIR/database_backup.sql"
            else
                echo "File database_backup.sql tidak ditemukan dalam arsip."
            fi

            rm -rf "$TEMP_DIR"
            ;;

        sql)
            echo "Memulihkan database..."
            mysql -u $DB_USER -p$DB_PASS $DB_NAME < "$BACKUP_FILE"
            ;;

        *)
            echo "Format file backup tidak dikenali."
            ;;
    esac

    echo "Pemulihan selesai!"
}

function install_domain {
    read -p "Masukkan nama domain: " DOMAIN
    WEB_ROOT="/var/www/$DOMAIN"
    CONFIG_FILE="/etc/apache2/sites-available/$DOMAIN.conf"

    echo "Membuat direktori root web..."
    sudo mkdir -p $WEB_ROOT

    echo "Mengatur izin..."
    sudo chown -R $USER:$USER $WEB_ROOT
    sudo chmod -R 755 $WEB_ROOT

    echo "Membuat index.html contoh..."
    echo "<html>
    <head>
        <title>Selamat datang di $DOMAIN!</title>
    </head>
    <body>
        <h1>Sukses! Virtual host $DOMAIN berfungsi!</h1>
    </body>
    </html>" | sudo tee $WEB_ROOT/index.html

    echo "Membuat file konfigurasi virtual host..."
    echo "<VirtualHost *:80>
        ServerAdmin admin@$DOMAIN
        ServerName $DOMAIN
        ServerAlias www.$DOMAIN
        DocumentRoot $WEB_ROOT
        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>" | sudo tee $CONFIG_FILE

    echo "Mengaktifkan virtual host..."
    sudo a2ensite $DOMAIN.conf

    echo "Menguji konfigurasi Apache..."
    sudo apache2ctl configtest

    echo "Memuat ulang Apache..."
    sudo systemctl reload apache2

    echo "Instalasi domain selesai!"
}

function setup_https {
    install_certbot

    read -p "Masukkan nama domain untuk HTTPS (contoh: example.com): " DOMAIN
    sudo certbot --apache -d $DOMAIN

    echo "HTTPS telah diatur untuk $DOMAIN!"
}

function replace_domain {
    read -p "Masukkan nama domain baru: " DOMAIN
    WEB_ROOT="/var/www/$DOMAIN"
    CONFIG_FILE="/etc/apache2/sites-available/$DOMAIN.conf"

    echo "Menghapus konfigurasi domain lama jika ada..."
    sudo a2dissite *.conf
    sudo rm -f /etc/apache2/sites-available/*.conf

    echo "Membuat konfigurasi baru untuk domain $DOMAIN..."
    echo "<VirtualHost *:80>
        ServerAdmin admin@$DOMAIN
        ServerName $DOMAIN
        ServerAlias www.$DOMAIN
        DocumentRoot $WEB_ROOT
        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>" | sudo tee $CONFIG_FILE

    echo "Mengaktifkan virtual host baru..."
    sudo a2ensite $DOMAIN.conf

    echo "Menguji konfigurasi Apache..."
    sudo apache2ctl configtest

    echo "Memuat ulang Apache..."
    sudo systemctl reload apache2

    echo "Domain telah diperbarui menjadi $DOMAIN!"
}

function create_or_replace_db {
    local action=$(dialog --clear --title "Database Management" --menu "Pilih opsi:" 15 50 4 \
        1 "Buat Database Baru" \
        2 "Ganti Database, Username, dan Password" \
        3 "Kembali" \
        2>&1 >/dev/tty)

    case $action in
        1)
            read -p "Masukkan nama database baru: " NEW_DB_NAME
            mysql -u $DB_USER -p$DB_PASS -e "CREATE DATABASE $NEW_DB_NAME;"
            echo "Database $NEW_DB_NAME telah dibuat."
            ;;
        2)
            read -p "Masukkan nama database baru: " NEW_DB_NAME
            read -p "Masukkan nama pengguna baru: " NEW_DB_USER
            read -p "Masukkan password pengguna baru: " NEW_DB_PASS

            echo "Mengganti database dan pengguna lama dengan baru..."

            # Buat database baru
            mysql -u $DB_USER -p$DB_PASS -e "CREATE DATABASE $NEW_DB_NAME;"
            # Buat pengguna baru dan berikan hak akses
            mysql -u $DB_USER -p$DB_PASS -e "CREATE USER '$NEW_DB_USER'@'localhost' IDENTIFIED BY '$NEW_DB_PASS';"
            mysql -u $DB_USER -p$DB_PASS -e "GRANT ALL PRIVILEGES ON $NEW_DB_NAME.* TO '$NEW_DB_USER'@'localhost';"
            mysql -u $DB_USER -p$DB_PASS -e "FLUSH PRIVILEGES;"

            # Hapus database dan pengguna lama
            mysql -u $DB_USER -p$DB_PASS -e "DROP DATABASE $DB_NAME;"
            mysql -u $DB_USER -p$DB_PASS -e "DROP USER '$DB_USER'@'localhost';"

            # Update variabel global
            DB_NAME=$NEW_DB_NAME
            DB_USER=$NEW_DB_USER
            DB_PASS=$NEW_DB_PASS

            echo "Database, pengguna, dan password telah diperbarui."
            ;;
        3)
            return
            ;;
        *)
            echo "Opsi tidak valid!"
            ;;
    esac
}

# Install dialog jika belum terpasang
install_dialog

while true; do
    CHOICE=$(dialog --clear --title "Menu Utama" --menu "Pilih opsi:" 15 50 11 \
        1 "Perbarui Sistem" \
        2 "Instal Apache" \
        3 "Instal MySQL" \
        4 "Instal PHP (7.4 & 8.1)" \
        5 "Instal phpMyAdmin" \
        6 "Backup Data" \
        7 "Pulihkan Cadangan" \
        8 "Instal Domain" \
        9 "Setup HTTPS" \
        10 "Ganti Domain" \
        11 "Ganti Database, Username, dan Password" \
        12 "Keluar" \
        2>&1 >/dev/tty)

    case $CHOICE in
        1) update_system ;;
        2) install_apache ;;
        3) install_mysql ;;
        4) install_php ;;
        5) install_phpmyadmin ;;
        6) backup_data ;;
        7) restore_backup ;;
        8) install_domain ;;
        9) setup_https ;;
        10) replace_domain ;;
        11) create_or_replace_db ;;
        12) echo "Keluar..."; exit 0 ;;
        *) echo "Opsi tidak valid!";;
    esac
done
