# Prometheus API Ruby Client

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
