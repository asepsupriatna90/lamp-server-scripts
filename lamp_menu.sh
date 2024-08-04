#!/bin/bash

# Definisikan variabel
BACKUP_DIR="/var/backups"
WEB_ROOT="/var/www/html"
DB_NAME="nama_database_anda"
DB_USER="user_database_anda"
DB_PASS="password_database_anda"

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
    sudo bash -c "echo 'Require valid-user' >> /usr/share/phpmyadmin/.htaccess"
    sudo htpasswd -c /etc/phpmyadmin/.htpasswd admin

    echo "phpMyAdmin berhasil diinstal dan dikonfigurasi!"
}

function restore_backup {
    echo "Pilih file backup untuk dipulihkan:"
    select FILE in $BACKUP_DIR/*; do
        if [[ -f $FILE ]]; then
            BACKUP_FILE=$FILE
            break
        else
            echo "File tidak valid. Silakan pilih lagi."
        fi
    done

    echo "Memulihkan file website dari $BACKUP_FILE..."
    sudo rsync -av --delete "$BACKUP_FILE/web_files/" "$WEB_ROOT/"

    echo "Memulihkan database dari $BACKUP_FILE..."
    mysql -u $DB_USER -p$DB_PASS $DB_NAME < "$BACKUP_FILE/database_backup.sql"

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
    </html>" > $WEB_ROOT/index.html

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

while true; do
    echo "============================="
    echo "Menu Utama"
    echo "============================="
    echo "1. Perbarui Sistem"
    echo "2. Instal Apache"
    echo "3. Instal MySQL"
    echo "4. Instal PHP (7.4 & 8.1)"
    echo "5. Instal phpMyAdmin"
    echo "6. Pulihkan Cadangan"
    echo "7. Instal Domain"
    echo "8. Keluar"
    read -p "Pilih opsi [1-8]: " choice

    case $choice in
        1) update_system ;;
        2) install_apache ;;
        3) install_mysql ;;
        4) install_php ;;
        5) install_phpmyadmin ;;
        6) restore_backup ;;
        7) install_domain ;;
        8) echo "Keluar..."; exit 0 ;;
        *) echo "Opsi tidak valid!";;
    esac
done
