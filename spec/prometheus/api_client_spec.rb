# encoding: UTF-8

require 'prometheus/api_client'

describe Prometheus::ApiClient do
  describe '.client' do
    it 'returne a client object' do
      client = Prometheus::ApiClient.client

      expect(client).to be_a(Prometheus::ApiClient::Client)
    end
  end
end
