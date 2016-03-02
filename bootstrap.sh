#!/bin/bash

yum groupinstall -y "Development Tools"

yum -y install \
	emacs emacs-common emacs-nox git wget \
	screen curl-devel openssl-devel readline-devel \
	java-1.7.0 wget

rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
yum -y install mysql-community-server mysql-community-client mysql-community-devel mysql-community-common mysql-community-libs mysql-community-release

cp /vagrant/archivesspace-v1.3.0.zip /home/
cd /home/
wget https://github.com/archivesspace/archivesspace/releases/download/v1.3.0/archivesspace-v1.3.0.zip
unzip archivesspace-v1.3.0.zip
rm -f archivesspace-v1.3.0.zip

## copy over local configs
cp -f /vagrant/config.rb /home/archivesspace/config/config.rb
cp -f /vagrant/archivesspace.sh /home/archivesspace/config/archivesspace.sh

## setup mysql
cd /home/archivesspace/lib
curl -Oq http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.36/mysql-connector-java-5.1.36.jar

systemctl enable mysqld
systemctl start mysqld

mysql -u root < /vagrant/mysqlSetup.sql
bash /home/archivesspace/scripts/setup-database.sh

/usr/sbin/useradd -M archivesspace
chown archivesspace /home/archivesspace/ -R

cd /etc/init.d
ln -s /home/archivesspace/archivesspace.sh archivesspace

chkconfig archivesspace on
/etc/init.d/archivesspace start
