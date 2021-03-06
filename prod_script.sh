#!/bin/bash

# Add repo with Mysql-6.6
add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty universe'
apt-get update

#install java-jdk 8
apt-get install default-jdk -y


# Install mysql server

echo "mysql-server-5.6 mysql-server/root_password password root" | sudo debconf-set-selections
echo "mysql-server-5.6 mysql-server/root_password_again password root" | sudo debconf-set-selections
apt-get -y install mysql-server-5.6


# move our mysql.cnf
cp /home/ubuntu/mysql.cnf /etc/mysql/conf.d/
systemctl start mysql.service

# create database and user fro confluence
pass=root

mysql -uroot -p$pass -e "CREATE DATABASE confluence"
mysql -uroot -p$pass -e "GRANT ALL PRIVILEGES ON confluence.* TO 'confluenceuser'@'localhost' IDENTIFIED BY 'confluencepass'"
mysql -uroot -p$pass -e "FLUSH PRIVILEGES;"

# download confluence and install
wget https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-6.2.1-x64.bin
chmod a+x /home/ubuntu/atlassian-confluence-6.2.1-x64.bin
sh atlassian-confluence-6.2.1-x64.bin <<-EOF
o
1
i
n
EOF

#download and install JDBC for confluence
wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.42.tar.gz
tar -zxvf mysql-connector-java-5.1.42.tar.gz

# copy JDBC to conflunece directory
cp /home/ubuntu/mysql-connector-java-5.1.42/mysql-connector-java-5.1.42-bin.jar /opt/atlassian/confluence/confluence/WEB-INF/lib/

#configration tomcat for nginx

cp /home/ubuntu/server.xml /opt/atlassian/confluence/conf/

 #star confluence
/etc/init.d/confluence start

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
ssh -fNR 4443:localhost:443 vagrant@ec2-13-58-84-169.us-east-2.compute.amazonaws.com
