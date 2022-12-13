echo 'Installing Please Wait'
echo "=================================================="
echo 'Setup Installer'
Install NPM
==================================================
sudo yum install epel-release -y
sudo yum install deltarpm -y
sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y

# TODO: Can't install postgres 9.6
sudo yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm -y
# TODO: Can't install NPM latest version
sudo curl -sL https://rpm.nodesource.com/setup_lts.x | sudo bash -

sudo yum install yum-utils -y
sudo yum update -y 

echo 'Install GIT'
echo "=================================================="
sudo yum install git -y


echo 'Install NPM'
echo "=================================================="
sudo yum install libstdc++.so.6 -y 
sudo yum install libm.so.6 -y
sudo yum install nodejs -y

echo 'Install Postgres'
echo "=================================================="
sudo yum install postgresql96 postgresql96-server postgresql96-contrib postgresql96-libs -y
sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb


echo 'Setup Postgres'
echo "=================================================="
sudo systemctl start postgresql-9.6.service
sudo systemctl enable postgresql-9.6.service


echo 'Install Apache'
echo "=================================================="
sudo yum install httpd -y


echo 'Install Redis'
echo "=================================================="
sudo yum install redis -y

echo 'Install PHP'
echo "=================================================="
sudo yum install php56-php php56-php-common php56-php-fpm -y
sudo yum install php74-php php74-php-common php74-php-fpm -y


echo "Install module php"
echo "=================================================="
sudo yum install php74-php-opcache     php56-php-opcache -y
sudo yum install php74-php-pdo         php56-php-pdo -y
sudo yum install php74-php-xml         php56-php-xml -y
sudo yum install php74-php-bcmath      php56-php-bcmath -y
sudo yum install php74-php-calendar    php56-php-calendar -y
sudo yum install php74-php-ctype       php56-php-ctype -y
sudo yum install php74-php-curl        php56-php-curl -y
sudo yum install php74-php-dom         php56-php-dom -y
sudo yum install php74-php-exif        php56-php-exif -y
sudo yum install php74-php-fileinfo    php56-php-fileinfo -y
sudo yum install php74-php-ftp         php56-php-ftp -y
sudo yum install php74-php-gd          php56-php-gd -y
sudo yum install php74-php-gettext     php56-php-gettext -y
sudo yum install php74-php-iconv       php56-php-iconv -y
sudo yum install php74-php-igbinary    php56-php-igbinary -y
sudo yum install php74-php-intl        php56-php-intl -y
sudo yum install php74-php-json        php56-php-json -y
sudo yum install php74-php-mbstring    php56-php-mbstring -y
sudo yum install php74-php-mcrypt      php56-php-mcrypt -y
sudo yum install php74-php-msgpack     php56-php-msgpack -y
sudo yum install php74-php-mysql       php56-php-mysql -y
sudo yum install php74-php-mysqli      php56-php-mysqli -y
sudo yum install php74-php-pdo_mysql   php56-php-pdo_mysql -y
sudo yum install php74-php-pdo_pgsql   php56-php-pdo_pgsql -y
sudo yum install php74-php-pdo_sqlite  php56-php-pdo_sqlite -y
sudo yum install php74-php-pgsql       php56-php-pgsql -y
sudo yum install php74-php-phar        php56-php-phar -y
sudo yum install php74-php-posix       php56-php-posix -y
sudo yum install php74-php-readline    php56-php-readline -y
sudo yum install php74-php-redis       php56-php-redis -y
sudo yum install php74-php-shmop       php56-php-shmop -y
sudo yum install php74-php-simplexml   php56-php-simplexml -y
sudo yum install php74-php-sockets     php56-php-sockets -y
sudo yum install php74-php-sqlite3     php56-php-sqlite3 -y
sudo yum install php74-php-sysvmsg     php56-php-sysvmsg -y
sudo yum install php74-php-sysvsem     php56-php-sysvsem -y
sudo yum install php74-php-sysvshm     php56-php-sysvshm -y
sudo yum install php74-php-tokenizer   php56-php-tokenizer -y
sudo yum install php74-php-wddx        php56-php-wddx -y
sudo yum install php74-php-xmlreader   php56-php-xmlreader -y
sudo yum install php74-php-xmlwriter   php56-php-xmlwriter -y
sudo yum install php74-php-xsl         php56-php-xsl -y
sudo yum install php74-php-zip         php56-php-zip -y
sudo yum install php74-php-memcached   php56-php-memcached -y
sudo yum install php74-php-xdebug      php56-php-xdebug -y


echo "Create phpswitch"
echo "=================================================="
sudo ln -sfn /usr/bin/php56 /usr/bin/php
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
    ln -sfn /usr/bin/php56 /usr/bin/php
    echo "Success Active PHP 5.6"
else
    echo "Switching PHP"
    ln -sfn /usr/bin/php74 /usr/bin/php
    echo "Success Active PHP 7.4"
fi
EOF



echo "Setup FPM"
echo "=================================================="
sudo tee /etc/httpd/conf.d/000-default.conf << EOF
<VirtualHost *:80>
    ServerName localhost
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
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF


sudo sed -i 's/:9000/:9000/' /opt/remi/php56/root/etc/php-fpm.d/www.conf
sudo sed -i 's/:9000/:9001/' /etc/opt/remi/php74/php-fpm.d/www.conf
sudo rm -f /var/www/html/index.html && touch /var/www/html/index.php
sudo tee /var/www/html/index.php << EOF 
<?php phpinfo();
EOF

sudo httpd -k restart
sudo systemctl restart php56-php-fpm 
sudo systemctl restart php74-php-fpm 


echo 'Install Composer'
echo "=================================================="
sudo curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

echo "Install Supervisor"
echo "=================================================="
sudo yum -y install supervisor
sudo systemctl start supervisord
sudo systemctl enable supervisord


echo "Install Memcached"
echo "=================================================="
sudo yum install -y libevent libevent-devel
sudo yum install -y memcached
sudo systemctl start memcached
sudo httpd -k restart
