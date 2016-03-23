#!/bin/bash

yum groupinstall -y "Development Tools"

yum -y install \
	emacs emacs-common emacs-nox git wget \
	screen curl-devel openssl-devel readline-devel \
	java-1.7.0 wget

rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
yum -y install mysql-community-server mysql-community-client mysql-community-devel mysql-community-common mysql-community-libs mysql-community-release

echo "Setup archives space  -----------------------------------------------------"
echo "---------------------------------------------------------------------------"
cd /vagrant/src/
# wget https://github.com/archivesspace/archivesspace/releases/download/v1.4.2/archivesspace-v1.4.2.zip
unzip archivesspace-v1.4.2.zip
rm -f archivesspace-v1.4.2.zipar

## copy over local configs
echo "Copying Local Configs -----------------------------------------------------"
echo "---------------------------------------------------------------------------"
cp -f /vagrant/config.rb /vagrant/src/archivesspace/config/config.rb


echo "Custom Plugins  -----------------------------------------------------------"
echo "---------------------------------------------------------------------------"
cd /vagrant/src/archivesspace
rm -rf /vagrant/src/archivesspace/plugins
ln -s /vagrant/plugins /vagrant/src/archivesspace/plugins


## setup mysql
echo "Setting up Mysql ----------------------------------------------------------"
echo "---------------------------------------------------------------------------"
cd /vagrant/src/archivesspace/lib
curl -Oq http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.36/mysql-connector-java-5.1.36.jar

systemctl enable mysqld
systemctl start mysqld

mysql -u root < /vagrant/mysqlSetup.sql
bash /vagrant/src/archivesspace/scripts/setup-database.sh

/usr/sbin/useradd -M archivesspace
chown archivesspace /vagrant/src/archivesspace/ -R

cd /etc/init.d
ln -s /vagrant/src/archivesspace/archivesspace.sh archivesspace

chkconfig archivesspace on
/etc/init.d/archivesspace start
