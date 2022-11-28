# ~/bash Ubuntu 22.04
echo 'Installing Please Wait'
echo "=================================================="
sudo apt-get update 



echo 'Setup Repository'
echo "=================================================="
sudo apt install software-properties-common ca-certificates lsb-release apt-transport-https git -y
sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ jammy-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql-pgdg.list > /dev/null
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt update


echo 'Installing apache2'
echo "=================================================="
sudo apt install apache2 libapache2-mod-fcgid -y



echo "Install NPM"
echo "=================================================="
# Default npm version Lts.x
sudo apt-get install nodejs -y


echo "Install redis"
echo "=================================================="
sudo apt install redis redis-server redis-tools -y



echo "Install PGSQL"
echo "=================================================="
sudo apt-get install postgresql-9.6 -y



echo 'Install php5.6'
echo "=================================================="
sudo apt install php5.6 php5.6-fpm php5.6-pgsql php5.6-redis php5.6-memcached php5.6-mcrypt libapache2-mod-php5.6 -y

echo 'Install php7.4'
echo "=================================================="
sudo apt install php7.4 php7.4-fpm php7.4-pgsql php7.4-redis php7.4-memcached php7.4-mcrypt libapache2-mod-php7.4 -y



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
            SetHandler "proxy:fcgi://127.0.0.1:9000" #Default use php5.6-fpm
        </FilesMatch>

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF


sudo sed -i 's+listen = /run/php/php7.4-fpm.sock+listen = 9001+g' /etc/php/7.4/fpm/pool.d/www.conf
sudo sed -i 's+listen = /run/php/php5.6-fpm.sock+listen = 9000+g' /etc/php/5.6/fpm/pool.d/www.conf


sudo rm -f /var/www/html/index.html && echo "<?php phpinfo();" >> /var/www/html/index.php
sudo apachectl configtest
sudo service php5.6-fpm restart
sudo service php7.4-fpm restart
sudo service apache2 restart




echo "Install composer"
echo "=================================================="
sudo curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer




echo "Install supervisor"
echo "=================================================="
sudo apt install supervisor -y




echo "Install memcached"
echo "=================================================="
sudo apt install memcached libmemcached-tools