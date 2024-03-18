#!/bin/bash
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
sudo mkdir -p /var/www/html/sa
sudo bash -c 'cat <<EOF > /etc/httpd/conf.d/sa.conf
<Directory /var/www/html/sa>
    AllowOverride All
    Require all denied
</Directory>
EOF'
sudo bash -c 'cat <<EOF > /var/www/html/sa/.htaccess
AuthType Basic
AuthName "Private"
AuthUserFile /etc/httpd/myhttppasswd
Require valid-user
EOF'
sudo bash -c 'cat <<EOF > /var/www/html/sa/wstask.html
<html>
    <body>
        HI FROM WEB SERVER TASK
    </body>
</html>
EOF'
read -p "Please enter a new username: " username
read -sp "Please enter the password for the user $username: " password
sudo htpasswd -b -c /etc/httpd/myhttppasswd "$username" "$password"
sudo systemctl restart httpd