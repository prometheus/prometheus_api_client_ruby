# Prometheus API Ruby Client

[![Gem Version][1]](http://badge.fury.io/rb/prometheus-api-client)
[![Build Status][2]](http://travis-ci.org/yaacov/prometheus_api_client_ruby)
[![Code Climate][3]](https://codeclimate.com/github/yaacov/prometheus_api_client_ruby)
[![Coverage Status][4]](https://coveralls.io/github/yaacov/prometheus_api_client_ruby?branch=master)

A Ruby library for reading Prometheus metrics API.

[ With ssl and authentication proxy support, if used in a layer above the prometheus REST server ]

## Usage

### Overview

```ruby
require 'prometheus/api_client'

# returns a default client
prometheus = Prometheus::ApiClient.client

prometheus.get(
  "query_range",
  :query => "sum(container_cpu_usage_seconds_total{container_name=\"prometheus-hgv4s\",job=\"kubernetes-nodes\"})",
  :start => "2015-07-01T20:10:30.781Z",
  :end   => "2015-07-02T20:10:30.781Z",
  :step  => "120s"
)
```

## Tests

Install necessary development gems with `bundle install` and run tests with
rspec:

```bash
rake
```

[1]: https://badge.fury.io/rb/prometheus-api-client.svg
[2]: https://secure.travis-ci.org/yaacov/prometheus_api_client_ruby.svg?branch=master
[3]: https://codeclimate.com/github/yaacov/prometheus_apiclient_ruby.svg
[4]: https://coveralls.io/repos/github/yaacov/prometheus_api_client_ruby/badge.svg?branch=master
