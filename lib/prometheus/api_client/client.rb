# encoding: UTF-8

require 'json'
require 'faraday'

module Prometheus
  # Client is a ruby implementation for a Prometheus compatible api_client.
  module ApiClient
    # Client contains the implementation for a Prometheus compatible api_client.
    class Client
      class RequestError < StandardError; end

      # Default paramters for creating default client
      DEFAULT_ARGS = {
        url: 'http://localhost:9090',
        path: '/api/v1/',
        credentials: {},
        options: {
          open_timeout: 2,
          timeout: 5,
        },
      }.freeze

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
        options = DEFAULT_ARGS.merge(options)

        @client = Faraday.new(
          faraday_options(options),
        )
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
      def targets(options = {})
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

      # Add labels to simple query variables.
      #
      # Example:
      #     "cpu_usage" => "cpu_usage{labels...}"
      #     "sum(cpu_usage)" => "sum(cpu_usage{labels...})"
      #     "rate(cpu_usage[5m])" => "rate(cpu_usage{labels...}[5m])"
      #
      # Note:
      #     Not supporting more complex queries.
      def update_query(query, labels)
        query.sub(/(?<r>\[.+\])?(?<f>[)])?$/, "{#{labels}}\\k<r>\\k<f>")
      end

      # Helper function to evalueate the low level proxy option
      def faraday_proxy(options)
        options[:http_proxy_uri] if options[:http_proxy_uri]
      end

      # Helper function to evalueate the low level ssl option
      def faraday_verify_ssl(options)
        return unless options[:verify_ssl]

        {
          verify: options[:verify_ssl] != OpenSSL::SSL::VERIFY_NONE,
          cert_store: options[:ssl_cert_store],
        }
      end

      # Helper function to evalueate the low level headers option
      def faraday_headers(credentials)
        return unless credentials[:token]

        {
          Authorization: 'Bearer ' + credentials[:token].to_s,
        }
      end

      # Helper function to create the args for the low level client
      def faraday_options(options)
        {
          url: options[:url] + options[:path],
          proxy: faraday_proxy(options[:options]),
          ssl: faraday_verify_ssl(options[:options]),
          headers: faraday_headers(options[:credentials]),
          request: {
            open_timeout: options[:options][:open_timeout],
            timeout: options[:options][:timeout],
          },
        }
      end
    end
  end
end
