# encoding: UTF-8

require 'prometheus/api_client/client'

module Prometheus
  # Client is a ruby implementation for a Prometheus compatible api_client.
  module ApiClient
    # Returns a default client object
    def self.client
      @client ||= Client.new
    end
  end
end
