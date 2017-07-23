# Prometheus Ruby Client

A suite of reading metric primitives for Ruby that are exposed
through an API HTTP interface. Intended to be used together with a
[Prometheus server][1].

## Usage

### Overview

```ruby
require 'prometheus/api_client'

# returns a default registry
prometheus = Prometheus::ApiClient.api_client

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
