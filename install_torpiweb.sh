apt -y install php php-common apache2
cd /var/www/html
git clone https://github.com/carellan/torpiweb.git

cat <<EOF >> /etc/sudoers

www-data ALL=NOPASSWD: ALL

EOF

/etc/init.d/apache2 restart
