# encoding: UTF-8

require 'json'
require 'faraday'

module Prometheus
  # Client is a ruby implementation for a Prometheus compatible api_client.
  module ApiClient
    # Client contains the implementation for a Prometheus compatible api_client.
    class Client
      class RequestError < StandardError; end

      # Create a Prometheus API client:
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
      def initialize(options)
        @client = Faraday.new(options)
      end

      # Evaluates an instant query at a single point in time:
      #
      # @param [Hash] options
      # @option options [String] :query Prometheus expression query string.
      # @option options [String] :time  <rfc3339 | unix_timestamp> Evaluation
      #   timestamp. Optional.
      # @option options [String] :timeout Evaluation timeout. Optional.
      #   Defaults to and is capped by the value of the -query.timeout flag.
      #
      # The current server time is used if the time parameter is omitted.
      def query(options)
        run_command('query', options)
      end

      # Evaluates an expression query over a range of time:
      #
      # @param [Hash] options
      # @option options [String] :query Prometheus expression query string.
      # @option options [String] :start  <rfc3339 | unix_timestamp> Start
      #   timestamp.
      # @option options [String] :end  <rfc3339 | unix_timestamp> End timestamp.
      # @option options [String] :step  <duration> Query resolution step width.
      # @option options [String] :timeout Evaluation timeout. Optional.
      #   Defaults to and is capped by the value of the -query.timeout flag.
      #
      # The current server time is used if the time parameter is omitted.
      def query_range(options)
        run_command('query_range', options)
      end

      # Returns an overview of the current state of the Prometheus target
      # discovery:
      #
      # @param [Hash] options
      #
      # No options used.
      def targets(options)
        run_command('targets', options)
      end

      # Returns a list of label values for a provided label name:
      #
      # @param [String] label Label name
      # @param [Hash] options
      #
      # No options used.
      def label(label, options = {})
        run_command("label/#{label}/values", options)
      end

      # Issues a get request to the low level client.
      def get(command, options)
        @client.get(command, options)
      end

      # Issues a get request to the low level client, and evalueate the
      # response JSON.
      def run_command(command, options)
        response = get(command, options)

        JSON.parse(response.body)['data']
      rescue
        raise RequestError, 'Bad response from server'
      end
    end
  end
end
