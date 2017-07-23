# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'prometheus/api_client/version'

Gem::Specification.new do |s|
  s.name              = 'prometheus-api_client'
  s.version           = Prometheus::ApiClient::VERSION
  s.summary           = 'A suite of reading metric values' \
                        'that are exposed through an API interface.'
  s.authors           = ['Yaacov Zamir']
  s.email             = ['kobi.zamir@gmail.com']
  s.homepage          = 'https://github.com/prometheus/api_client_ruby'
  s.license           = 'Apache 2.0'

  s.files             = %w(README.md) + Dir.glob('{lib/**/*}')
  s.require_paths     = ['lib']

  s.add_dependency 'quantile', '~> 0.2.0'
end
