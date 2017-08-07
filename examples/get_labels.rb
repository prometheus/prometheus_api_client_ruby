require 'prometheus/api_client'

# returns a client
prometheus = Prometheus::ApiClient.client('http://example.com:8080')

prometheus.label('job')

# will result in an array containing the results data struct:
#
# ["kubernetes-apiservers", "kubernetes-cadvisor", "kubernetes-nodes",
#  "kubernetes-service-endpoints"]
