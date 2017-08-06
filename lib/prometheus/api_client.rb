# encoding: UTF-8

require 'uri'
require 'openssl'
require 'prometheus/api_client/client'

module Prometheus
  # Client is a ruby implementation for a Prometheus compatible api_client.
  module ApiClient
    DEFAULT_ENTRYPOINT = 'http://localhost:9090'.freeze
    DEFAULT_ARGS = {
      path: '/api/v1/',
      credentials: {},
      options: {
        open_timeout: 2,
        timeout: 5,
      },
    }.freeze

    # Returns a default client object
    def self.client(entrypoint = DEFAULT_ENTRYPOINT, args = {})
      args = DEFAULT_ARGS.merge(args)

      Client.new(
        prometheus_args(entrypoint, args),
      )
    end

    def self.prometheus_proxy(options)
      options[:http_proxy_uri] if options[:http_proxy_uri]
    end

    def self.prometheus_verify_ssl(options)
      return unless options[:verify_ssl]

      {
        verify: options[:verify_ssl] != OpenSSL::SSL::VERIFY_NONE,
        cert_store: options[:ssl_cert_store],
      }
    end

    def self.prometheus_headers(credentials)
      return unless credentials[:token]

      {
        Authorization: 'Bearer ' + credentials[:token].to_s,
      }
    end

    def self.prometheus_args(entrypoint, args = {})
      {
        url: entrypoint + args[:path],
        proxy: prometheus_proxy(args[:options]),
        ssl: prometheus_verify_ssl(args[:options]),
        headers: prometheus_headers(args[:credentials]),
        request: {
          open_timeout: args[:options][:open_timeout],
          timeout: args[:options][:timeout],
        },
      }
    end
  end
end
