# encoding: UTF-8

require 'prometheus/api_client'

describe Prometheus::ApiClient do
  describe '.client' do
    it 'memorizes the returned object' do
      client = Prometheus::ApiClient.client('http://localhost')
      expect(client).to be_a(Faraday::Connection)
    end
  end
end
