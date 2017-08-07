# encoding: UTF-8

require 'prometheus/api_client/client'

module Prometheus
  # Client is a ruby implementation for a Prometheus compatible api_client.
  module ApiClient
    # Client contains the implementation for a Prometheus compatible api_client,
    # With special labels for the cadvisor job.
    module Cadvisor
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
      class Node < Client
        def initialize(instance:, **options)
          region = options[:region] || 'infra'
          zone = options[:zone] || 'default'

          @labels = "job=\"kubernetes-cadvisor\",region=\"#{region}\"," \
            "zone=\"#{zone}\",instance=\"#{instance}\""
          super(options)
        end

        def query(options)
          options[:query] = update_query(options[:query], @labels)
          super(options)
        end

        def query_range(options)
          options[:query] = update_query(options[:query], @labels)
          super(options)
        end
      end

      # A client with special labels for pod cadvisor metrics
      class Pod < Client
        def initialize(pod_name:, **options)
          namespace = options[:namespace] || 'default'
          region = options[:region] || 'infra'
          zone = options[:zone] || 'default'

          @labels = "job=\"kubernetes-cadvisor\",region=\"#{region}\"," \
            "zone=\"#{zone}\",namespace=\"#{namespace}\"," \
            "pod_name=\"#{pod_name}\",container_name=\"POD\""
          super(options)
        end

        def query(options)
          options[:query] = update_query(options[:query], @labels)
          super(options)
        end

        def query_range(options)
          options[:query] = update_query(options[:query], @labels)
          super(options)
        end
      end

      # A client with special labels for container cadvisor metrics
      class Container < Client
        def initialize(container_name:, pod_name:, **options)
          namespace = args[:namespace] || 'default'
          region = options[:region] || 'infra'
          zone = options[:zone] || 'default'

          @labels = "job=\"kubernetes-cadvisor\",region=\"#{region}\"," \
            "zone=\"#{zone}\",namespace=\"#{namespace}\"," \
            "pod_name=\"#{pod_name}\",container_name=\"#{container_name}\""
          super(options)
        end

        def query(options)
          options[:query] = update_query(options[:query], @labels)
          super(options)
        end

        def query_range(options)
          options[:query] = update_query(options[:query], @labels)
          super(options)
        end
      end
    end
  end
end
