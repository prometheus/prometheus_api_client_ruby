# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'prometheus/api_client/version'

Gem::Specification.new do |s|
  s.name              = 'prometheus-api-client'
  s.version           = Prometheus::ApiClient::VERSION
  s.summary           = 'A suite of reading metrics stored on ' \
                        'a Prometheus server.'
  s.authors           = ['Yaacov Zamir']
  s.email             = ['kobi.zamir@gmail.com']
  s.homepage          = 'https://github.com/yaacov/prometheus_api_client_ruby'
  s.license           = 'Apache-2.0'

  s.files             = %w(README.md) + Dir.glob('{lib/**/*}')
  s.require_paths     = ['lib']

  s.add_dependency 'faraday', '~> 0.9.2'
end
