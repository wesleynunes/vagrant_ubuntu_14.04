#/usr/bin/env bash

echo "--- Instalando pacotes para desenvolvimento [PHP]"

# Use single quotes instead of double quotes to make it work with special-character passwords
echo "--- definir senha e nome do projeto ---"
PASSWORD='123'
PROJECTFOLDER='project'

echo "--- criar pasta do projeto ---"
sudo mkdir "/var/www/html/${PROJECTFOLDER}"

cho "--- criando arquivo index.php ---"
echo "<?php phpinfo(); ?>" > /var/www/html/${PROJECTFOLDER}/index.php

echo "--- update / upgrade ---"
sudo apt-get update
sudo apt-get -y upgrade

echo "--- instalar apache2 and php5 ---"
sudo apt-get -y install apache2
sudo apt-get -y install php5 libapache2-mod-php5 php5-mcrypt

echo "--- instalar mysql e fornercer senha para o instalador --- "
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get install php5-mysql

echo "--- instalar mysql e fornecer senha para o instalador ---"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

echo "--- arquivo host ---"
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/${PROJECTFOLDER}"
    <Directory "/var/www/html/${PROJECTFOLDER}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

echo "--- habilitar mod-rewrite do apache ---"
sudo a2enmod rewrite

echo "--- instalando git ---"
sudo apt-get -y install git 
git config --global user.name "Wes"  
git config --global user.email wesleysilva.ti@gmail.com

echo "-- instalar composer ---"
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

echo "--- reiniciar apache ---"
sudo service apache2 restart

echo "[OK] --- Ambiente de desenvolvimento concluido ---"