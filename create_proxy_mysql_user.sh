# Create a privileged user for the MySQL database for the proxy
sudo mysql -uroot -e "CREATE USER 'ubuntu'@'54.227.45.133' IDENTIFIED BY 'password';"
sudo mysql -uroot -e "GRANT ALL PRIVILEGES ON sakila.* TO 'ubuntu'@'54.227.45.133' WITH GRANT OPTION;"
sudo mysql -uroot -e "FLUSH PRIVILEGES;"
