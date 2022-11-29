# ~/bash Ubuntu 22.04
echo 'Installing Please Wait'
echo "=================================================="
sudo apt-get update 



echo 'Setup Repository'
echo "=================================================="
sudo apt-get install software-properties-common ca-certificates lsb-release apt-transport-https git -y
sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ jammy-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql-pgdg.list > /dev/null
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get update


echo 'Installing apache2'
echo "=================================================="
sudo apt-get install apache2 libapache2-mod-fcgid -y



echo "Install NPM"
echo "=================================================="
# Default npm version Lts.x
sudo apt-get install nodejs -y


echo "Install redis"
echo "=================================================="
sudo apt-get install redis redis-server redis-tools -y



echo "Install PGSQL"
echo "=================================================="
sudo apt-get install postgresql-9.6 -y



echo 'Install php5.6'
echo "=================================================="
sudo apt-get install php5.6 php5.6-fpm libapache2-mod-php5.6 -y

echo 'Install php7.4'
echo "=================================================="
sudo apt-get install php7.4 php7.4-fpm libapache2-mod-php7.4 -y




echo "Install Module PHP"
# Select Module PHP
sudo apt-get install php7.4-opcache     php5.6-opcache -y
sudo apt-get install php7.4-pdo         php5.6-pdo -y
sudo apt-get install php7.4-xml         php5.6-xml -y
sudo apt-get install php7.4-bcmath      php5.6-bcmath -y
sudo apt-get install php7.4-calendar    php5.6-calendar -y
sudo apt-get install php7.4-ctype       php5.6-ctype -y
sudo apt-get install php7.4-curl        php5.6-curl -y
sudo apt-get install php7.4-dom         php5.6-dom -y
sudo apt-get install php7.4-exif        php5.6-exif -y
sudo apt-get install php7.4-fileinfo    php5.6-fileinfo -y
sudo apt-get install php7.4-ftp         php5.6-ftp -y
sudo apt-get install php7.4-gd          php5.6-gd -y
sudo apt-get install php7.4-gettext     php5.6-gettext -y
sudo apt-get install php7.4-iconv       php5.6-iconv -y
sudo apt-get install php7.4-igbinary    php5.6-igbinary -y
sudo apt-get install php7.4-intl        php5.6-intl -y
sudo apt-get install php7.4-json        php5.6-json -y
sudo apt-get install php7.4-mbstring    php5.6-mbstring -y
sudo apt-get install php7.4-mcrypt      php5.6-mcrypt -y
sudo apt-get install php7.4-msgpack     php5.6-msgpack -y
sudo apt-get install php7.4-mysql       php5.6-mysql -y
sudo apt-get install php7.4-mysqli      php5.6-mysqli -y
sudo apt-get install php7.4-pdo_mysql   php5.6-pdo_mysql -y
sudo apt-get install php7.4-pdo_pgsql   php5.6-pdo_pgsql -y
sudo apt-get install php7.4-pdo_sqlite  php5.6-pdo_sqlite -y
sudo apt-get install php7.4-pgsql       php5.6-pgsql -y
sudo apt-get install php7.4-phar        php5.6-phar -y
sudo apt-get install php7.4-posix       php5.6-posix -y
sudo apt-get install php7.4-readline    php5.6-readline -y
sudo apt-get install php7.4-redis       php5.6-redis -y
sudo apt-get install php7.4-shmop       php5.6-shmop -y
sudo apt-get install php7.4-simplexml   php5.6-simplexml -y
sudo apt-get install php7.4-sockets     php5.6-sockets -y
sudo apt-get install php7.4-sqlite3     php5.6-sqlite3 -y
sudo apt-get install php7.4-sysvmsg     php5.6-sysvmsg -y
sudo apt-get install php7.4-sysvsem     php5.6-sysvsem -y
sudo apt-get install php7.4-sysvshm     php5.6-sysvshm -y
sudo apt-get install php7.4-tokenizer   php5.6-tokenizer -y
sudo apt-get install php7.4-wddx        php5.6-wddx -y
sudo apt-get install php7.4-xmlreader   php5.6-xmlreader -y
sudo apt-get install php7.4-xmlwriter   php5.6-xmlwriter -y
sudo apt-get install php7.4-xsl         php5.6-xsl -y
sudo apt-get install php7.4-zip         php5.6-zip -y
sudo apt-get install php7.4-memcached   php5.6-memcached -y
sudo apt-get install php7.4-xdebug      php5.6-xdebug -y





echo "Create phpswitch"
echo "=================================================="
sudo touch /usr/local/bin/phpswitch
sudo chmod +x /usr/local/bin/phpswitch
sudo tee /usr/local/bin/phpswitch << EOF 
#!/bin/bash
if [ "\$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

IS_PHP5=\`php --version | grep "PHP 5.6"\`

if  [ -z "\$IS_PHP5" ]
then
    echo "Switching PHP"
    ln -sfn /usr/bin/php5.6 /usr/bin/php
    echo "Success Active PHP 5.6"
else
    echo "Switching PHP"
    ln -sfn /usr/bin/php7.4 /usr/bin/php
    echo "Success Active PHP 7.4"
fi
EOF



echo "Setup fpm"
echo "=================================================="
sudo a2enconf php5.6-fpm php7.4-fpm

sudo a2dismod mpm_prefork
sudo a2enmod proxy_fcgi proxy mpm_event rewrite

# Generate 000-default.conf
sudo tee /etc/apache2/sites-available/000-default.conf << EOF 
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        <Directory /var/www/site1.your_domain>
            Options Indexes FollowSymLinks
            AllowOverride All
            allow from all
        </Directory>


        <FilesMatch \.php$>
            # Port 9000 = PHP5.6-FPM
            # Port 9001 = PHP7.4-FPM
            SetHandler "proxy:fcgi://127.0.0.1:9000"
        </FilesMatch>

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF


sudo sed -i 's+listen = /run/php/php7.4-fpm.sock+listen = 9001+g' /etc/php/7.4/fpm/pool.d/www.conf
sudo sed -i 's+listen = /run/php/php5.6-fpm.sock+listen = 9000+g' /etc/php/5.6/fpm/pool.d/www.conf


sudo rm -f /var/www/html/index.html && touch /var/www/html/index.php
sudo tee /var/www/html/index.php << EOF 
<?php phpinfo();
EOF

sudo apachectl configtest
sudo service php5.6-fpm restart
sudo service php7.4-fpm restart
sudo service apache2 restart




echo "Install composer"
echo "=================================================="
sudo curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer




echo "Install supervisor"
echo "=================================================="
sudo apt-get install supervisor -y




echo "Install memcached"
echo "=================================================="
sudo apt-get install memcached libmemcached-tools -y



echo 'cleanup'
echo "=================================================="
sudo apt-get -f install
sudo apt-get autoremove
sudo apt-get -y autoclean 
sudo apt-get -y clean 

