require 'prometheus/api_client'

# returns a client
prometheus = Prometheus::ApiClient.client(url: 'http://example.com:8080')

prometheus.query_range(
  query: 'container_cpu_usage_seconds_total{id="/"}',
  start: '2017-08-07T06:10:30.781Z',
  end:   '2017-08-07T06:14:30.781Z',
  step:  '120s',
)

# will result in a hash containing the results data struct:
#
# {"resultType"=>"matrix",
# "result"=>
#  [{"metric"=>
#     {"__name__"=>"container_cpu_usage_seconds_total",
#      "beta_kubernetes_io_arch"=>"amd64",
#      "beta_kubernetes_io_os"=>"linux",
#      "cpu"=>"cpu00",
#      "id"=>"/",
#      "instance"=>"example.com",
#      "job"=>"kubernetes-cadvisor",
#      "kubernetes_io_hostname"=>"example.com",
#      "region"=>"infra",
#      "zone"=>"default"},
#    "values"=>[[1502086230.781, "51264.830099022"],
#               [1502086470.781, "51277.367732154"]]},
#   {"metric"=>
#     {"__name__"=>"container_cpu_usage_seconds_total",
#      "beta_kubernetes_io_arch"=>"amd64",
#      "beta_kubernetes_io_os"=>"linux",
#      "cpu"=>"cpu01",
#      "id"=>"/",
#      "instance"=>"example.com",
#      "job"=>"kubernetes-cadvisor",
#      "kubernetes_io_hostname"=>"example.com",
#      "region"=>"infra",
#      "zone"=>"default"},
#    "values"=>[[1502086230.781, "53879.644934689"],
#               [1502086470.781, "53892.665282065"]]}]}
