# encoding: UTF-8

require 'prometheus/api_client'
require 'webmock'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
end

describe Prometheus::ApiClient::Cadvisor do
  token = 'toSecret'
  url = 'https://prometheus.example.com'

  instance = 'example.com'
  pod_name = 'prometheus-1552260379-fq410'
  container_name = 'prometheus'

  describe 'Node' do
    it 'reads metrics' do
      VCR.use_cassette('prometheus/api_client/cadvisor') do # , record: :new_episodes) do
        prometheus = Prometheus::ApiClient::Cadvisor::Node.new(
          instance:    instance,
          url:         url,
          credentials: { token: token },
          options:     { verify_ssl: OpenSSL::SSL::VERIFY_NONE },
        )

        response = prometheus.query(
          query: 'sum(container_cpu_usage_seconds_total)',
          time: '2017-08-20T06:10:30.781Z',
        )

        expect(response).to be_a(Hash)
      end
    end

    it 'reads metrics for all nodes' do
      VCR.use_cassette('prometheus/api_client/cadvisor') do # , record: :new_episodes) do
        prometheus = Prometheus::ApiClient::Cadvisor::Node.new(
          url:         url,
          credentials: { token: token },
          options:     { verify_ssl: OpenSSL::SSL::VERIFY_NONE },
        )

        response = prometheus.query(
          query: 'sum(container_cpu_usage_seconds_total)',
          time: '2017-08-20T06:10:30.781Z',
        )

        expect(response).to be_a(Hash)
      end
    end

    it 'reads metrics range' do
      VCR.use_cassette('prometheus/api_client/cadvisor') do # , record: :new_episodes) do
        prometheus = Prometheus::ApiClient::Cadvisor::Node.new(
          instance:    instance,
          url:         url,
          credentials: { token: token },
          options:     { verify_ssl: OpenSSL::SSL::VERIFY_NONE },
        )

        response = prometheus.query_range(
          query: 'sum(container_cpu_usage_seconds_total)',
          start: '2017-08-20T06:10:30.781Z',
          end:   '2017-08-20T06:40:30.781Z',
          step:  '120s',
        )

        expect(response).to be_a(Hash)
      end
    end
  end

  describe 'Pod' do
    it 'reads metrics' do
      VCR.use_cassette('prometheus/api_client/cadvisor') do # , record: :new_episodes) do
        prometheus = Prometheus::ApiClient::Cadvisor::Pod.new(
          pod_name:    pod_name,
          url:         url,
          credentials: { token: token },
          options:     { verify_ssl: OpenSSL::SSL::VERIFY_NONE },
        )

        response = prometheus.query(
          query: 'sum(container_cpu_usage_seconds_total)',
          time: '2017-08-20T06:10:30.781Z',
        )

        expect(response).to be_a(Hash)
      end
    end

    it 'reads metrics for all pods' do
      VCR.use_cassette('prometheus/api_client/cadvisor') do # , record: :new_episodes) do
        prometheus = Prometheus::ApiClient::Cadvisor::Pod.new(
          url:         url,
          credentials: { token: token },
          options:     { verify_ssl: OpenSSL::SSL::VERIFY_NONE },
        )

        response = prometheus.query(
          query: 'sum(container_cpu_usage_seconds_total)',
          time: '2017-08-20T06:10:30.781Z',
        )

        expect(response).to be_a(Hash)
      end
    end

    it 'reads metrics range' do
      VCR.use_cassette('prometheus/api_client/cadvisor') do # , record: :new_episodes) do
        prometheus = Prometheus::ApiClient::Cadvisor::Pod.new(
          pod_name:    pod_name,
          url:         url,
          credentials: { token: token },
          options:     { verify_ssl: OpenSSL::SSL::VERIFY_NONE },
        )

        response = prometheus.query_range(
          query: 'sum(container_cpu_usage_seconds_total)',
          start: '2017-08-20T06:10:30.781Z',
          end:   '2017-08-20T06:40:30.781Z',
          step:  '120s',
        )

        expect(response).to be_a(Hash)
      end
    end
  end

  describe 'Container' do
    it 'reads metrics' do
      VCR.use_cassette('prometheus/api_client/cadvisor') do # , record: :new_episodes) do
        prometheus = Prometheus::ApiClient::Cadvisor::Container.new(
          container_name: container_name,
          pod_name:       pod_name,
          url:            url,
          credentials:    { token: token },
          options:        { verify_ssl: OpenSSL::SSL::VERIFY_NONE },
        )

        response = prometheus.query(
          query: 'sum(container_cpu_usage_seconds_total)',
          time: '2017-08-20T06:10:30.781Z',
        )

        expect(response).to be_a(Hash)
      end
    end

    it 'reads metrics for all containers' do
      VCR.use_cassette('prometheus/api_client/cadvisor') do # , record: :new_episodes) do
        prometheus = Prometheus::ApiClient::Cadvisor::Container.new(
          url:            url,
          credentials:    { token: token },
          options:        { verify_ssl: OpenSSL::SSL::VERIFY_NONE },
        )

        response = prometheus.query(
          query: 'sum(container_cpu_usage_seconds_total)',
          time: '2017-08-20T06:10:30.781Z',
        )

        expect(response).to be_a(Hash)
      end
    end

    it 'reads metrics range' do
      VCR.use_cassette('prometheus/api_client/cadvisor') do # , record: :new_episodes) do
        prometheus = Prometheus::ApiClient::Cadvisor::Container.new(
          container_name: container_name,
          pod_name:       pod_name,
          url:            url,
          credentials:    { token: token },
          options:        { verify_ssl: OpenSSL::SSL::VERIFY_NONE },
        )

        response = prometheus.query_range(
          query: 'sum(container_cpu_usage_seconds_total)',
          start: '2017-08-20T06:10:30.781Z',
          end:   '2017-08-20T06:40:30.781Z',
          step:  '120s',
        )

        expect(response).to be_a(Hash)
      end
    end
  end
end
