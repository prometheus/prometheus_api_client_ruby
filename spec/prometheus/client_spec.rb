# encoding: UTF-8

require 'prometheus/api_client'

describe Prometheus::ApiClient do
  describe '.client' do
    it 'memorizes the returned object' do
      expect(Prometheus::ApiClient.client('https://example.com')).to be_a(Faraday::Connection)
    end
  end
end
