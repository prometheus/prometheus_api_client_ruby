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

prometheus.get(
  'query_range',
  query: 'sum(container_cpu_usage_seconds_total' \
         '{container_name="prometheus-hgv4s",job="kubernetes-nodes"})',
  start: '2015-07-01T20:10:30.781Z',
  end:   '2015-07-02T20:10:30.781Z',
  step:  '120s',
)
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

#### High level calls

```ruby

# send a query request to server
prometheus.query(
  query: 'sum(container_cpu_usage_seconds_total' \
         '{container_name="prometheus-hgv4s",job="kubernetes-nodes"})',
  time:  '2015-07-01T20:10:30.781Z',
)
```

```ruby
# send a query_range request to server
prometheus.query_range(
  query: 'sum(container_cpu_usage_seconds_total' \
         '{container_name="prometheus-hgv4s",job="kubernetes-nodes"})',
  start: '2015-07-01T20:10:30.781Z',
  end:   '2015-07-02T20:10:30.781Z',
  step:  '120s',
)

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

```ruby
# send a label request to server
prometheus.label('__name__')

# response from server:
["kubernetes-apiservers", "kubernetes-cadvisor", "kubernetes-nodes",
 "kubernetes-service-endpoints"]
```

```ruby
# send a targets request to server
prometheus.targets()
```

#### cAdvisor specialize client

```ruby

# create a client for cAdvisor metrics of a Node instance 'example.com'
# connected to a Prometheus server listening on http://example.com:8080
prometheus = Prometheus::ApiClient::Cadvisor::Node.new(
  instance: 'example.com',
  url:      'http://example.com:8080',
)

# send a query request to server
prometheus.query(
  query: 'sum(container_cpu_usage_seconds_total)',
  time:  '2015-07-01T20:10:30.781Z',
)
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
