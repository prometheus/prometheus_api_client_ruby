# encoding: UTF-8

require 'json'
require 'faraday'

module Prometheus
  # Client is a ruby implementation for a Prometheus compatible api_client.
  module ApiClient
    # Client contains the implementation for a Prometheus compatible api_client.
    class Client
      class RequestError < StandardError; end

      def initialize(args)
        @client = Faraday.new(args)
      end

      def query(options)
        run_command('query', options)
      end

      def query_range(options)
        run_command('query_range', options)
      end

      def label(tag, options = {})
        run_command("label/#{tag}/values", options)
      end

      def get(command, options)
        @client.get(command, options)
      end

      def run_command(command, options)
        response = get(command, options)

        JSON.parse(response.body)['data']
      rescue
        raise RequestError, 'Bad response from server'
      end
    end
  end
end
