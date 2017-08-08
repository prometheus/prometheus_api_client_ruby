# encoding: UTF-8

require 'prometheus/api_client'
require 'fakeweb'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = "spec/vcr_cassettes"
  c.hook_into :fakeweb
  c.allow_http_connections_when_no_cassette = false
end

describe Prometheus::ApiClient::Cadvisor do
  token = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJtYW5hZ2VtZW50LWluZnJhIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6Im1hbmFnZW1lbnQtYWRtaW4tdG9rZW4tejBncmYiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoibWFuYWdlbWVudC1hZG1pbiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjEzYjgxZjI0LTcyOTktMTFlNy04MjIxLTAwMWE0YTIzMTRkNyIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDptYW5hZ2VtZW50LWluZnJhOm1hbmFnZW1lbnQtYWRtaW4ifQ.G_ht7AJi1sd73vH8fO8_fZyjYA2-Qpz_M2DJ0JrjiBTBzISfJcUZETLN_ZRQUhqicWtEe3YWmN2lVY-7OoAl24v5mr-_9Qax_p44TUzBgNqng0wl-kXi4Ay6uoTtf470w0QuBMgJGnB05-nxA52G24doZQG493wGqxmKr5OLePJ0cg7vlG6wUjxznbG-u8lQM1qt59CHKzxPc_pgWMtSBHlXisuYV9dwNFLlfvwIHQZwc1qq72eMud9PtorD6QontuHAARLNTieCtrjlKk6-EFH5zOWXDukNyFPcMD43FGLqBxFkqboHaa04iEivViUrmXVvB6CqkOZoNPxSrG98LQ'
  url = 'https://prometheus.10.35.19.248.nip.io:443'
  instance = 'yzamir-centos7-3.eng.lab.tlv.redhat.com'

  describe 'Node' do
    it 'reads metrics' do
      VCR.use_cassette('prometheus/api_client/cadvisor_node', :record => :new_episodes) do
        prometheus = Prometheus::ApiClient::Cadvisor::Node.new(
          instance:    instance,
          url:         url,
          credentials: { token: token },
          options:     { verify_ssl: OpenSSL::SSL::VERIFY_NONE },
        )

        response = prometheus.query(
          query: 'sum(container_cpu_usage_seconds_total)',
          time: '2017-08-07T06:10:30.781Z',
        )

        expect(response).to be_a(Hash)
      end
    end

    it 'reads metrics range' do
      VCR.use_cassette('spec/vcr/prometheus/api_client/cadvisor_node', :record => :new_episodes) do
        prometheus = Prometheus::ApiClient::Cadvisor::Node.new(
          instance:    instance,
          url:         url,
          credentials: { token: token },
          options:     { verify_ssl: OpenSSL::SSL::VERIFY_NONE },
        )

        response = prometheus.query_range(
          query: 'sum(container_cpu_usage_seconds_total)',
          start: '2017-08-07T06:10:30.781Z',
          end:   '2017-08-07T06:14:30.781Z',
          step:  '120s',
        )

        expect(response).to be_a(Hash)
      end
    end
  end
end
