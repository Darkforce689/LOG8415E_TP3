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

# Execute the proxy script
source venv/bin/activate
sudo python3 proxy.py