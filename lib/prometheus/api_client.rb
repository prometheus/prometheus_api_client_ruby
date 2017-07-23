# encoding: UTF-8

require 'faraday'

module Prometheus
  # Client is a ruby implementation for a Prometheus compatible api_client.
  module ApiClient
    # Returns a default client object
    def self.client
      @client ||= prometheus_client('https://prometheus.com')
    end

    def self.prometheus_args(credentials, options)
      {
        proxy: options[:http_proxy_uri],
        headers: { Authorization: 'Bearer ' + credentials[:token].to_s },
        ssl: if options[:verify_ssl]
               {
                 verify: options[:verify_ssl] != OpenSSL::SSL::VERIFY_NONE,
                 cert_store: options[:ssl_cert_store],
               }
             end,
      }
    end

    def self.prometheus_client(uri, credentials = {}, options = {})
      args = { url: uri.to_s, request: { open_timeout: 2, timeout: 5 } }

      Faraday.new(args.merge(prometheus_args(credentials, options)))
    end
  end
end
