require 'prometheus/api_client'

# returns a client, with authentication proxy support
prometheus = Prometheus::ApiClient.client(url: 'https://example.com:443',
                                          credentials: { token: 'TopSecret' })

prometheus.query(
  query: 'container_cpu_usage_seconds_total{id="/"}',
  time: '2017-08-07T06:10:30.781Z',
)

# will result in a hash containing the results data struct:
#
# {"resultType"=>"vector",
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
#    "value"=>[1502089057.125, "51412.007276689"]},
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
#    "value"=>[1502089057.125, "54034.698666487"]}]}
