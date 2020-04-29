apt -y install php php-common apache2
cd /var/www/html
git clone https://github.com/carellan/torpiweb.git
/etc/init.d/apache2 restart
