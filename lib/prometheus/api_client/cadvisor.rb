# encoding: UTF-8

require 'prometheus/api_client/client'

module Prometheus
  # Client is a ruby implementation for a Prometheus compatible api_client.
  module ApiClient
    # Client contains the implementation for a Prometheus compatible api_client,
    # With special labels for the cadvisor job.
    module Cadvisor
      # A client with special labels for cadvisor metrics
      class CadvisorClient < Client
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

        # Issues a get request to the low level client.
        # Update the query options to use specific labels
        def get(command, options)
          options[:query] = update_query(options[:query], @labels)
          @client.get(command, options)
        end
      end

      # A client with special labels for node cadvisor metrics
      class Node < CadvisorClient
        def initialize(options = {})
          instance = options[:instance]

          @labels = "job=\"kubernetes-cadvisor\",instance=\"#{instance}\"," \
            'id="/"'
          super(options)
        end
      end

      # A client with special labels for pod cadvisor metrics
      class Pod < CadvisorClient
        def initialize(options = {})
          pod_name = options[:pod_name]
          namespace = options[:namespace] || 'default'

          @labels = "job=\"kubernetes-cadvisor\",namespace=\"#{namespace}\"," \
            "pod_name=\"#{pod_name}\",container_name=\"POD\""
          super(options)
        end
      end

      # A client with special labels for container cadvisor metrics
      class Container < CadvisorClient
        def initialize(options = {})
          container_name = options[:container_name]
          pod_name = options[:pod_name]
          namespace = options[:namespace] || 'default'

          @labels = "job=\"kubernetes-cadvisor\",namespace=\"#{namespace}\"," \
            "pod_name=\"#{pod_name}\",container_name=\"#{container_name}\""
          super(options)
        end
      end
    end
  end
end
