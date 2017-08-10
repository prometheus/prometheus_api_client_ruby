# Prometheus API Ruby Client

[![Gem Version][1]](http://badge.fury.io/rb/prometheus-api-client)
[![Build Status][2]](http://travis-ci.org/yaacov/prometheus_api_client_ruby)
[![Build Status][3]](https://codeclimate.com/github/yaacov/prometheus_api_client_ruby)
[![Coverage Status][4]](https://coveralls.io/github/yaacov/prometheus_api_client_ruby?branch=master)

A Ruby library for reading metrics stored on a Prometheus server.

## Install

```
gem install prometheus-api-client
```

## Usage

### Overview

```ruby
require 'prometheus/api_client'

# return a client for host http://localhost:9090/api/v1/
prometheus = Prometheus::ApiClient.client
```

#### Changing server hostname

```ruby
# return a client for host http://example.com:9090/api/v1/
prometheus = Prometheus::ApiClient.client(url: 'http://example.com:9090')
```

#### Authentication proxy

If an authentication proxy ( e.g. oauth2 ) is used in a layer above the
prometheus REST server, this client can use ssl and authentication headears.

```ruby
# return a client for host https://example.com/api/v1/ using a Bearer token "TopSecret"
prometheus = Prometheus::ApiClient.client(url:         'https://example.com:443',
                                          credentials: { token: 'TopSecret' })
```

#### Low lavel calls

###### query

```ruby

# send a low level get request to server
prometheus.get(
  'query_range',
  query: 'sum(container_cpu_usage_seconds_total' \
         '{container_name="prometheus-hgv4s",job="kubernetes-nodes"})',
  start: '2015-07-01T20:10:30.781Z',
  end:   '2015-07-02T20:10:30.781Z',
  step:  '120s',
)
```
```
# response from server is a low level response struct including
# fields like: method, body and request_headers
# usually users will not need to use this law level calls
   ...
   method=:get,
   body="{\"status\":\"success\",
   ...
```
#### High level calls

###### query

```ruby

# send a query request to server
prometheus.query(
  query: 'sum(container_cpu_usage_seconds_total' \
         '{container_name="prometheus-hgv4s",job="kubernetes-nodes"})',
  time:  '2015-07-01T20:10:30.781Z',
)
```
```
# response from server:
{"resultType"=>"vector", "result"=>[{"metric"=>{}, "value"=>[1502350741.161, "6606.310387038"]}]}
```
###### query_range

```ruby
# send a query_range request to server
prometheus.query_range(
  query: 'sum(container_cpu_usage_seconds_total' \
         '{container_name="prometheus-hgv4s",job="kubernetes-nodes"})',
  start: '2015-07-01T20:10:30.781Z',
  end:   '2015-07-02T20:10:30.781Z',
  step:  '120s',
)
```
```
# response from server:
{"resultType"=>"matrix",
 "result"=>
  [{"metric"=>
     {"__name__"=>"container_cpu_usage_seconds_total",
      "beta_kubernetes_io_arch"=>"amd64",
      "beta_kubernetes_io_os"=>"linux",
      "cpu"=>"cpu00",
      "id"=>"/",
      "instance"=>"example.com",
      "job"=>"kubernetes-cadvisor",
      "kubernetes_io_hostname"=>"example.com",
      "region"=>"infra",
      "zone"=>"default"},
    "values"=>[[1502086230.781, "51264.830099022"],
               [1502086470.781, "51277.367732154"]]},
   {"metric"=>
     {"__name__"=>"container_cpu_usage_seconds_total",
      "beta_kubernetes_io_arch"=>"amd64",
      "beta_kubernetes_io_os"=>"linux",
      "cpu"=>"cpu01",
      "id"=>"/",
      "instance"=>"example.com",
      "job"=>"kubernetes-cadvisor",
      "kubernetes_io_hostname"=>"example.com",
      "region"=>"infra",
      "zone"=>"default"},
    "values"=>[[1502086230.781, "53879.644934689"],
               [1502086470.781, "53892.665282065"]]}]}
```

###### label

```ruby
# send a label request to server
prometheus.label('__name__')
```
```
# response from server:
["APIServiceRegistrationController_adds",
 "APIServiceRegistrationController_depth",
 ...

```

###### targets

```ruby
# send a targets request to server
prometheus.targets()
```
```
# response from server:
{"activeTargets"=>
  [{"discoveredLabels"=>
     {"__address__"=>"10.35.19.248:8443",
      "__meta_kubernetes_endpoint_port_name"=>"https",
      "__meta_kubernetes_endpoint_port_protocol"=>"TCP",
      "__meta_kubernetes_endpoint_ready"=>"true",
      "__meta_kubernetes_endpoints_name"=>"kubernetes",
      "__meta_kubernetes_namespace"=>"default",
      "__meta_kubernetes_service_label_component"=>"apiserver",
      "__meta_kubernetes_service_label_provider"=>"kubernetes",
      "__meta_kubernetes_service_name"=>"kubernetes",
      "__metrics_path__"=>"/metrics",
      "__scheme__"=>"https",
      "job"=>"kubernetes-apiservers"},
    "labels"=>{"instance"=>"10.35.19.248:8443", "job"=>"kubernetes-apiservers"},
    "scrapeUrl"=>"https://10.35.19.248:8443/metrics",
    "lastError"=>"",
    "lastScrape"=>"2017-08-10T07:35:40.919376413Z",
    "health"=>"up"},
    ...

```

#### cAdvisor specialize client

A cAdvisor client is a client that add object specific labels to each REST call,
objects available are Node, Pod and Container.

###### Node

Add the instance label, user must declare the instance on client creation.

###### Pod

Add the pod_name label, user must declare the pod_name on client creation.

###### Container

Add the container_name and pod_name labels, user must declare container_name and pod_name on client creation.

###### Example

```ruby

# create a client for cAdvisor metrics of a Node instance 'example.com'
# connected to a Prometheus server listening on http://example.com:8080
prometheus = Prometheus::ApiClient::Cadvisor::Node.new(
  instance: 'example.com',
  url:      'http://example.com:8080',
)

# send a query request to server
prometheus.query(query: 'sum(container_cpu_usage_seconds_total)')
```
```
# response from server:
{"resultType"=>"vector", "result"=>[{"metric"=>{}, "value"=>[1502350741.161, "6606.310387038"]}]}
```

## Tests

Install necessary development gems with `bundle install` and run tests with
rspec:

```bash
rake
```

[1]: https://badge.fury.io/rb/prometheus-api-client.svg
[2]: https://secure.travis-ci.org/yaacov/prometheus_api_client_ruby.svg
[3]: https://codeclimate.com/github/yaacov/prometheus_api_client_ruby.svg
[4]: https://coveralls.io/repos/github/yaacov/prometheus_api_client_ruby/badge.svg
