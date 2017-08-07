# encoding: UTF-8

require 'uri'
require 'openssl'
require 'prometheus/api_client/client'

module Prometheus
  # Api Client is a ruby implementation for a Prometheus compatible api_client.
  module ApiClient
    # Default paramters for creating default client
    DEFAULT_ENTRYPOINT = 'http://localhost:9090'.freeze
    DEFAULT_ARGS = {
      path: '/api/v1/',
      credentials: {},
      options: {
        open_timeout: 2,
        timeout: 5,
      },
    }.freeze

    # Create a Prometheus API client:
    #
    # @param [String] entrypoint The Prometheus server url.
    #
    # @param [Hash] options
    # @option options [Hash] :url String base URL.
    # @option options [Hash] :params URI query unencoded key/value pairs.
    # @option options [Hash] :headers Unencoded HTTP header key/value pairs.
    # @option options [Hash] :request Request options.
    # @option options [Hash] :ssl SSL options.
    # @option options [Hash] :proxy Proxy options.
    #
    # A default client is created if options is omitted.
    def self.client(entrypoint = DEFAULT_ENTRYPOINT, options = {})
      options = DEFAULT_ARGS.merge(options)

      Client.new(
        prometheus_args(entrypoint, options),
      )
    end

    # Helper function to evalueate the low level proxy option
    def self.prometheus_proxy(options)
      options[:http_proxy_uri] if options[:http_proxy_uri]
    end

    # Helper function to evalueate the low level ssl option
    def self.prometheus_verify_ssl(options)
      return unless options[:verify_ssl]

      {
        verify: options[:verify_ssl] != OpenSSL::SSL::VERIFY_NONE,
        cert_store: options[:ssl_cert_store],
      }
    end

    # Helper function to evalueate the low level headers option
    def self.prometheus_headers(credentials)
      return unless credentials[:token]

      {
        Authorization: 'Bearer ' + credentials[:token].to_s,
      }
    end

    # Helper function to create the args for the low level client
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
