# The following script is referenced from: https://www.digitalocean.com/community/tutorials/how-to-create-a-multi-node-mysql-cluster-on-ubuntu-18-04

# Install the MySQL Cluster Management Server
sudo apt-get update && sudo apt-get install -y libncurses5 sysbench libaio1 libmecab2

cd ~
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb
sudo mkdir /var/lib/mysql-cluster

echo "
[ndbd default]
# Options affecting ndbd processes on all data nodes:
NoOfReplicas=3	# Number of replicas

[ndb_mgmd]
# Management process options:
hostname=ip-172-31-16-10.ec2.internal # Hostname of the manager
datadir=/var/lib/mysql-cluster 	# Directory for the log files

[ndbd]
hostname=ip-172-31-16-11.ec2.internal # Hostname/IP of the first data node
NodeId=2			# Node ID for this data node
datadir=/usr/local/mysql/data	# Remote directory for the data files

[ndbd]
hostname=ip-172-31-16-12.ec2.internal # Hostname/IP of the second data node
NodeId=3			# Node ID for this data node
datadir=/usr/local/mysql/data	# Remote directory for the data files

[ndbd]
hostname=ip-172-31-16-13.ec2.internal # Hostname/IP of the third data node
NodeId=4			# Node ID for this data node
datadir=/usr/local/mysql/data	# Remote directory for the data files

[mysqld]
# SQL node options:
hostname=ip-172-31-16-10.ec2.internal" | sudo tee -a /var/lib/mysql-cluster/config.ini

echo "
[Unit]
Description=MySQL NDB Cluster Management Server
After=network.target auditd.service

[Service]
Type=forking
ExecStart=/usr/sbin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/ndb_mgmd.service

sudo systemctl daemon-reload
sudo systemctl enable ndb_mgmd
sudo systemctl start ndb_mgmd

# Set up the MySQL Cluster
cd ~
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar
sudo mkdir install
sudo tar -xvf mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar -C install/

cd install
sudo dpkg -i mysql-common_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-client_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-client_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-server_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-server_7.6.6-1ubuntu18.04_amd64.deb

echo "
[mysqld]
# Options for mysqld process:
ndbcluster
bind-address=0.0.0.0

[mysql_cluster]
# Options for NDB Cluster processes:
ndb-connectstring=ip-172-31-16-10.ec2.internal" | sudo tee -a /etc/mysql/my.cnf

sudo systemctl restart mysql
sudo systemctl enable mysql

# Install the Sakila sample database
sudo wget https://downloads.mysql.com/docs/sakila-db.tar.gz
sudo tar -xvzf sakila-db.tar.gz
sudo cp -r sakila-db /home/

# Populate the database structure from Sakila
sudo mysql -uroot -e "SOURCE /home/sakila-db/sakila-schema.sql;"
sudo mysql -uroot -e "SOURCE /home/sakila-db/sakila-data.sql;"