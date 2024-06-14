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

  describe '.run_command' do
    it 'returns a hash' do
      VCR.use_cassette('prometheus/api_client/client') do # , record: :new_episodes) do
        prometheus = Prometheus::ApiClient::Client.new(
          url:         url,
          credentials: { token: token },
          options:     { verify_ssl: OpenSSL::SSL::VERIFY_NONE },
        )

        response = prometheus.run_command(
          "query_range",
          { query: "up", start: "2015-07-01T20:10:30.781Z", end: "2015-07-01T20:11:00.781Z", step: "15s"}
        )

        expect(response).to eq({ "resultType"=>"matrix", "result"=>[], "explanation" => nil })
      end
    end

    it 'raises on error' do
      VCR.use_cassette('prometheus/api_client/client') do # , record: :new_episodes) do
        prometheus = Prometheus::ApiClient::Client.new(
          url:         url,
          credentials: { token: token },
          options:     { verify_ssl: OpenSSL::SSL::VERIFY_NONE },
        )

        expect { prometheus.run_command("query_ranage", { query: "(not a valid command"}) } .to raise_error(Prometheus::ApiClient::Client::RequestError)
      end
    end
  end
end
