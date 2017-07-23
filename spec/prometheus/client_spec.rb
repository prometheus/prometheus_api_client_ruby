# encoding: UTF-8

require 'prometheus/api_client'

describe Prometheus::ApiClient do
  describe '.client' do
    it 'returns a client object' do
      expect(Prometheus::ApiClient.client).to be_a(
        Prometheus::ApiClient::Client,
      )
    end

    it 'memorizes the returned object' do
      expect(Prometheus::ApiClient.client).to eql(Prometheus::ApiClient.client)
    end
  end
end
