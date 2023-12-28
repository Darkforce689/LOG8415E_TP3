# Update the package lists and install dependencies
sudo apt-get update
sudo apt-get install -y python3 python3-pip
sudo apt install -y python3-flask
sudo apt install -y python3.10-venv
pip3 install virtualenv

# Create and activate the virtual environment
python3 -m venv venv
source venv/bin/activate

# Install needed Python libraries
sudo pip3 install flask requests pymysql pythonping sshtunnel

# Install ufw and iptables-persistent
sudo apt-get install -y ufw
sudo apt install -y iptables-persistent

# Open the necessary ports
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable

# Only allow incoming and outgoing TCP connections on ports 80 and 443
sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo netfilter-persistent save

# Activate the virtual environment
source venv/bin/activate
# Execute the gatekeeper script
sudo python3 gatekeeper.py