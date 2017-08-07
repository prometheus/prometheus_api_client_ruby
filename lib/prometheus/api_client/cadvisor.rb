# encoding: UTF-8

require 'prometheus/api_client/client'

module Prometheus
  # Client is a ruby implementation for a Prometheus compatible api_client.
  module ApiClient
    # Client contains the implementation for a Prometheus compatible api_client,
    # With special labels for the cadvisor job.
    module Cadvisor
      # A client with special labels for node cadvisor metrics
      class Node < Client
        def initialize(options = {})
          instance = options[:instance]

          @labels = "job=\"kubernetes-cadvisor\",instance=\"#{instance}\"," \
            'id="/"'
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
        def initialize(options = {})
          pod_name = options[:pod_name]
          namespace = options[:namespace] || 'default'

          @labels = "job=\"kubernetes-cadvisor\",namespace=\"#{namespace}\"," \
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
        def initialize(options = {})
          container_name = args[:container_name]
          pod_name = args[:pod_name]
          namespace = args[:namespace] || 'default'

          @labels = "job=\"kubernetes-cadvisor\",namespace=\"#{namespace}\"," \
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
