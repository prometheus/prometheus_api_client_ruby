# encoding: UTF-8

require 'prometheus/api_client'
require 'webmock'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
end

describe Prometheus::ApiClient::Client do
  token = 'toSecret'
  url = 'https://prometheus.example.com:443'

  describe '.label' do
    it 'reads labels' do
      VCR.use_cassette('prometheus/api_client/client') do # , record: :new_episodes) do
        prometheus = Prometheus::ApiClient::Client.new(
          url:         url,
          credentials: { token: token },
          options:     { verify_ssl: OpenSSL::SSL::VERIFY_NONE },
        )

        response = prometheus.label('job')

        expect(response).to be_a(Array)
      end
    end
  end

  describe '.targets' do
    it 'reads targets' do
      VCR.use_cassette('prometheus/api_client/client') do # , record: :new_episodes) do
        prometheus = Prometheus::ApiClient::Client.new(
          url:         url,
          credentials: { token: token },
          options:     { verify_ssl: OpenSSL::SSL::VERIFY_NONE },
        )

        response = prometheus.targets

        expect(response).to be_a(Hash)
      end
    end
  end
end
