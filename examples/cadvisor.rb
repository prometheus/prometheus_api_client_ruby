require 'prometheus/api_client'

# returns a client for cadvisor node data ( for node instance 'example.com' )
prometheus = Prometheus::ApiClient::Cadvisor::Node.new(
  instance: 'example.com',
  url: 'http://example.com:8080',
)

prometheus.query_range(
  query: 'sum(container_cpu_usage_seconds_total)',
  start: '2017-08-07T06:10:30.781Z',
  end:   '2017-08-07T06:14:30.781Z',
  step:  '120s',
)

# will result in a hash containing the results data struct:
#
# {"resultType"=>"matrix", "result"=>[{"metric"=>{}, "values"=>
#    [[1502086230.781, "314016.35813638807"],
#    [1502086350.781, "5125.822337834"],
#    [1502086470.781, "314093.6892872209"]]}]}
