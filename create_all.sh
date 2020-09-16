# Create Elastic cluster
helm repo add elastic https://helm.elastic.co
helm upgrade --install elasticsearch  elastic/elasticsearch -f elasticsearch/values.yaml --version 7.9.1  

# Create Elastic metric exporter
helm upgrade --install elasticsearch-exporter stable/elasticsearch-exporter -f elasticsearch-exporter/values.yaml --version 3.7.0

# Create Prometheus operator and dependencies (CRDs)
sh ./prometheus-operation/create_crds.sh
helm repo add prometheus-com https://prometheus-community.github.io/helm-charts
helm upgrade --install prometheus-operator prometheus-community/kube-prometheus-stack -f prometheus-operation/values.yaml --version 9.4.2

# For Grafana Elastic dashboard, this link might be useful https://grafana.com/grafana/dashboards/7259

# Optional :: if nginx-ingress-controller is not installed yet.
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install my-release ingress-nginx/ingress-nginx


# Is my serviceMonitor get discovered ?
kubectl -n monitoring get secret prometheus-prometheus-operator-kube-p-prometheus -ojson | jq -r '.data["prometheus.yaml.gz"]' | base64 -d | gunzip | grep node