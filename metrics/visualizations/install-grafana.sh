# !!! Follow install-prometheus.sh first

# Update system and add grafana to packages
sudo apt-get update -y
sudo apt-get install wget curl gnupg2 apt-transport-https software-properties-common -y
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a 
/etc/apt/sources.list.d/grafana.list
sudo apt-get update -y

# Install grafana
sudo apt-get install grafana -y
grafana-server -v
systemctl start grafana-server
systemctl enable grafana-server

# Test Installation
systemctl status grafana-server

# An example grafana.json is attached with the dashboard configuration - for openssl tests.