wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz

tar -xzvf node_exporter-1.5.0.linux-amd64.tar.gz
sudo useradd -rs /bin/false nodeusr
sudo mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin/node_exporter

sudo vim /etc/systemd/system/node_exporter.service

# Add the following statements to the vim file
<<com
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=nodeusr
Group=nodeusr
Type=simple
EnvironmentFile=/etc/default/node_exporter
ExecStart=bash -c '/usr/local/bin/node_exporter/node_exporter $OPTIONS'

[Install]
WantedBy=multi-user.target
com

# Start Node exporter Service and make it persistent over a shutdown

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
sudo systemctl status node_exporter

# Test node_exporter
curl http://localhost:9100/metrics




#Custom Metrics

mkdir /var/lib/node_exporter
sudo -i 
echo "OPTIONS='--collector.textfile.directory=/var/lib/node_exporter'" > /etc/default/node_exporter

# Restart node exporter to apply changes
systemctl restart node_exporter
journalctl -eu node_exporter

# Any custom metric has to be written to the files in /var/lib/node_exporter/<metric_name>.prom


# Example - Consider metrics.py 
# Store metrics.py in a safe (non editable) location
# Create a shell script to run metrics.py
sudo vim /usr/local/bin/metric.sh

# Add the following contents to the metrics.sh file and edit <path_to_metrics_file> and <metrics_name>
<<com
#!/bin/bash
i=0

while [ $i -lt 12 ]; do
  sudo bash -c 'python3 <path_to_metrics_file>/metric.py > /var/lib/node_exporter/<metric_name>.prom'
  sleep 5
  i=$(( i + 1 ))
done
com

sudo chmod +x /usr/local/bin/metric.sh

# Create a cron job using the following commands
sudo -i 
crontab -e

# Add the following in one line
<<com
* * * * * /usr/local/bin/metric.sh
com

# any metric written to the <metric_name>.prom file has to be of the format
# <metric_name>_<metric:instance> {<metric:attributes>} <value>
# Custom Metric is Created !! - It will run every 5 seconds
