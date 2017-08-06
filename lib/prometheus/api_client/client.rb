# encoding: UTF-8

require 'faraday'

module Prometheus
  # Client is a ruby implementation for a Prometheus compatible api_client.
  module ApiClient
    # Client contains the implementation for a Prometheus compatible api_client.
    class Client
      def initialize(args)
        @client = Faraday.new(args)
      end

      def get(args)
        @client.get(args)
      end
    end
  end
end
