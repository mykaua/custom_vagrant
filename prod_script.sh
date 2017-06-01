#!/bin/bash

add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty universe'
apt-get update

apt-get install default-jdk -y




echo "mysql-server-5.6 mysql-server/root_password password root" | sudo debconf-set-selections
echo "mysql-server-5.6 mysql-server/root_password_again password root" | sudo debconf-set-selections
apt-get -y install mysql-server-5.6



cp /home/ubuntu/mysql.cnf /etc/mysql/conf.d/
systemctl start mysql.service


mysql -uroot -p$pass -e "CREATE DATABASE confluence"
mysql -uroot -p$pass -e "GRANT ALL PRIVILEGES ON confluence.* TO 'confluenceuser'@'localhost' IDENTIFIED BY 'confluencepass'"

wget https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-6.2.1-x64.bin
chmod a+x /home/ubuntu/atlassian-confluence-X.X.X-x64.bin
sh atlassian-confluence-6.2.1-x64.bin <<-EOF
o
1
i
n
EOF

#download and install JDBC for confluence
wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.42.tar.gz
tar -zxvf mysql-connector-java-5.1.42.tar.gz

cp /home/ubuntu/mysql-connector-java-5.1.42/mysql-connector-java-5.1.42-bin.jar /opt/atlassian/confluence/confluence/WEB-INF/lib/

 #star confluence
 sudo /etc/init.d/confluence start

#install nginx
apt-get update
apt-get install nginx -y

# add our confg
rm -rf /etc/nginx/sites-available/*
rm -rf /etc/nginx/sites-enabled/*

cp /home/ubuntu/nginx /etc/nginx/sites-available/defaul_ssl.conf

ln -s /etc/nginx/sites-available/defaul_ssl.conf /etc/nginx/sites-enabled/default

# install ssl cert
mkdir /etc/nginx/ssl

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt  -subj "/C=UA/ST=Lviv/L=Lviv/O=IT/CN=conf.myka.pp.ua"

#restart nginx service
systemctl restart nginx.service


#SSH tunnel
ssh -o "StrictHostKeyChecking=no"  -fNR 4443:localhost:443 vagrant@localhost
