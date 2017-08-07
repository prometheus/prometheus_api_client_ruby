# encoding: UTF-8

require 'uri'
require 'openssl'
require 'prometheus/api_client/client'
require 'prometheus/api_client/cadvisor'

module Prometheus
  # Api Client is a ruby implementation for a Prometheus compatible api_client.
  module ApiClient
    # Create a Prometheus API client:
    #
    # @param [Hash] options
    # @option options [String] :url Server base URL.
    # @option options [Hash] :params URI query unencoded key/value pairs.
    # @option options [Hash] :headers Unencoded HTTP header key/value pairs.
    # @option options [Hash] :request Request options.
    # @option options [Hash] :ssl SSL options.
    # @option options [Hash] :proxy Proxy options.
    #
    # A default client is created if options is omitted.
    def self.client(options = {})
      Client.new(options)
    end
  end
end
