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
      # @option options [String] :url Server base URL.
      # @option options [Hash] :credentials Authentication credentials.
      # @option options [Hash] :options Options used to define connection.
      # @option options [Hash] :headers Unencoded HTTP header key/value pairs.
      # @option options [Hash] :request Request options.
      # @option options [Hash] :ssl SSL options.
      # @option options [String] :proxy Proxy url.
      #
      # A default client is created if options is omitted.
      def initialize(options = {})
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
      rescue StandardError => err
        raise RequestError, err.message
      end

      # Helper function to evalueate the low level proxy option
      def faraday_proxy(options)
        return options[:proxy] if options[:proxy]

        proxy = options[:options]
        proxy[:http_proxy_uri] if proxy[:http_proxy_uri]
      end

      # Helper function to evalueate the low level ssl option
      def faraday_ssl(options)
        return options[:ssl] if options[:ssl]

        ssl = options[:options]
        return unless ssl[:verify_ssl] || ssl[:ssl_cert_store]

        {
          verify: ssl[:verify_ssl] != OpenSSL::SSL::VERIFY_NONE,
          cert_store: ssl[:ssl_cert_store],
        }
      end

      # Helper function to evalueate the low level headers option
      def faraday_headers(options)
        return options[:headers] if options[:headers]

        headers = options[:credentials]
        return unless headers && headers[:token]

        {
          Authorization: 'Bearer ' + headers[:token].to_s,
        }
      end

      # Helper function to evalueate the low level headers option
      def faraday_request(options)
        return options[:request] if options[:request]

        request = options[:options]
        return unless request[:open_timeout] || request[:timeout]

        {
          open_timeout: request[:open_timeout],
          timeout: request[:timeout],
        }
      end

      # Helper function to create the args for the low level client
      def faraday_options(options)
        {
          url: options[:url] + options[:path],
          proxy: faraday_proxy(options),
          ssl: faraday_ssl(options),
          headers: faraday_headers(options),
          request: faraday_request(options),
        }
      end
    end
  end
end
