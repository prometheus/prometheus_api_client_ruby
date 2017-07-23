# encoding: UTF-8

module Prometheus
  module ApiClient
    # Client
    class Client
      def initialize
        @client = nil
      end

      def client
        @client ||= 'Client'
      end
    end
  end
end
