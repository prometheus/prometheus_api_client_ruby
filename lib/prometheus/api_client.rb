# encoding: UTF-8

require 'uri'
require 'faraday'

module Prometheus
  # Client is a ruby implementation for a Prometheus compatible api_client.
  module ApiClient
    DEFAULT_HOST = 'localhost'.freeze
    DEFAULT_SCHEME = 'http'.freeze
    DEFAULT_PORT = 9090
    DEFAULT_PATH = '/api/v1/'.freeze
    DEFAULT_CREDENTIALS = {}.freeze
    DEFAULT_OPTIONS = {}.freeze

    # Returns a default client object
    def self.client(host = DEFAULT_HOST, args = {})
      args = {
        scheme: DEFAULT_SCHEME,
        port: DEFAULT_PORT,
        path: DEFAULT_PATH,
        credentials: DEFAULT_CREDENTIALS,
        options: DEFAULT_OPTIONS,
      }.merge(args)

      Faraday.new(
        prometheus_args(host, args),
      )
    end

    def self.prometheus_uri(host, scheme, port, path)
      builder = {
        http: URI::HTTP,
        https: URI::HTTPS,
      }[scheme.to_sym]

      builder.build(
        host: host,
        port: port,
        path: path,
      ).to_s
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

    def self.prometheus_args(host, args = {})
      {
        url: prometheus_uri(
          host, args[:scheme], args[:port], args[:path]
        ),
        proxy: prometheus_proxy(args[:options]),
        ssl: prometheus_verify_ssl(args[:options]),
        headers: prometheus_headers(args[:credentials]),
        request: { open_timeout: 2, timeout: 5 },
      }
    end
  end
end
