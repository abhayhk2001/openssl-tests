# Metrics Management

Using Node exporter, Prometheus, Grafana stack to collect and visualize metrics.

Use the [node_exporter.sh](collection/install-node-exporter.sh) file to install node exporter in the test VM, eanble it as a service and create a custom metric that is exported. An example of metric to run is given.

Create a New VM and use [install-promethues.sh](visualizations/install-prometeus.sh) file to install promethues and collect data from teh API expoised by node_exporter. Then use [install-grafana.sh](visualizations/install-grafana.sh) file to install grafana to visualize the data.

To create a minimalistic dashboard for node exporter data use the [dashboard.json](visualizations/dashboard.json) dashboard configuration file.