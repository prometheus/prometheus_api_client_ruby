require 'prometheus/api_client'

# returns a default client
prometheus = Prometheus::ApiClient.client

prometheus.get(
  'query_range',
  query: 'sum(container_cpu_usage_seconds_total{job="kubernetes-cadvisor"})',
  start: '2015-07-01T20:10:30.781Z',
  end:   '2015-07-02T20:10:30.781Z',
  step:  '120s',
)

# will result in a low level Response object:
#
# <Faraday::Response:0x0055d24b49b998
# @env=
#  #<struct Faraday::Env
#   method=:get,
#   body=
# ...
