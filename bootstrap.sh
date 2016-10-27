#!/bin/bash

VERSION=1.5.1

yum groupinstall -y "Development Tools"

yum -y install \
	emacs emacs-common emacs-nox git wget \
	screen curl-devel openssl-devel readline-devel \
	java-1.7.0 wget

rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
yum -y install mysql-community-server mysql-community-client mysql-community-devel mysql-community-common mysql-community-libs mysql-community-release cabextract
rpm -Uvh msttcore-fonts-installer-2.6-1.noarch.rpm

cp /opt/archivesspace/archivesspace-v$VERSION.zip /home/
cd /home/
wget https://github.com/archivesspace/archivesspace/releases/download/v$VERSION/archivesspace-v$VERSION.zip
unzip archivesspace-v$VERSION.zip
rm -f archivesspace-v$VERSION.zip

## copy over local configs
cp -f /opt/archivesspace/config.rb /home/archivesspace/config/config.rb
cp -f /opt/archivesspace/archivesspace.sh /home/archivesspace/config/archivesspace.sh

## setup mysql
cd /home/archivesspace/lib
curl -Oq http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.36/mysql-connector-java-5.1.36.jar

systemctl enable mysqld
systemctl start mysqld

mysql -u root < /opt/archivesspace/mysqlSetup.sql
bash /home/archivesspace/scripts/setup-database.sh

/usr/sbin/useradd -M archivesspace
chown archivesspace /home/archivesspace/ -R

cd /etc/init.d
ln -s /home/archivesspace/archivesspace.sh archivesspace

chkconfig archivesspace on
/etc/init.d/archivesspace start
