# frozen_string_literal: true

RSpec.describe Faraday::Adapter::Typhoeus do
  features :request_body_on_query_methods,
           :reason_phrase_parse,
           # transparent compression IS supported but tests will fail b/c
           # webmock is unaware of this
           #  :compression,
           :streaming,
           :trace_method

  # Runs the tests provide by Faraday, according to the features specified above.
  it_behaves_like 'an adapter'

  let(:base_url) { 'http://example.com' }
  let(:adapter) { described_class.new(nil) }
  let(:request) { Typhoeus::Request.new(base_url) }

  # TODO: context "when a response is stubbed"

  describe '#initialize' do
    let(:request) { adapter.method(:typhoeus_request).call({}) }

    context 'when no options specified' do
      let(:adapter) { described_class.new(nil) }
      it 'defers to curl on accepted encodings' do
        expect(request.options[:accept_encoding]).to eq('')
      end
    end

    context 'when typhoeus request options specified' do
      let(:adapter) { described_class.new(nil, { forbid_reuse: true, maxredirs: 1 }) }

      it 'should set options for request' do
        expect(request.options[:forbid_reuse]).to be_truthy
        expect(request.options[:maxredirs]).to eq(1)
      end
    end
  end

  describe '#perform_request' do
    let(:env) { {} }

    context 'when body' do
      let(:env) { { body: double(read: 'body') } }

      it 'reads body' do
        expect(adapter.method(:read_body).call(env)).to eq('body')
      end
    end

    context 'parallel_manager' do
      context 'when given' do
        let(:env) { { parallel_manager: double(queue: true), ssl: {}, request: {} } }

        it 'uses' do
          adapter.method(:perform_request).call(env)
        end
      end

      context 'when not given' do
        let(:env) { { method: :get, ssl: {}, request: {} } }

        it 'falls back to single' do
          expect(Typhoeus::Request).to receive(:new).and_return(double(options: {}, on_complete: [], run: true))
          adapter.method(:perform_request).call(env)
        end
      end
    end
  end

  describe '#request' do
    let(:env) do
      { url: 'url', method: :get, body: 'body', request_headers: {}, ssl: {}, request: {} }
    end

    let(:request) { adapter.method(:request).call(env) }

    it 'returns request' do
      expect(request).to be_a(Typhoeus::Request)
    end

    it 'sets url' do
      expect(request.base_url).to eq('url')
    end

    it 'sets http method' do
      expect(request.original_options[:method]).to eq(:get)
    end

    it 'sets body' do
      expect(request.original_options[:body]).to eq('body')
    end

    it 'sets headers' do
      expect(request.original_options[:headers]).to eq({})
    end

    it 'sets on_complete callback' do
      expect(request.on_complete.size).to eq(1)
    end
  end

  describe '#configure_socket' do
    let(:env) { { request: { bind: { host: 'interface' } } } }

    before { adapter.method(:configure_socket).call(request, env) }

    context 'when host' do
      it 'sets interface' do
        expect(request.options[:interface]).to eq('interface')
      end
    end
  end

  describe '#configure_timeout' do
    before { adapter.method(:configure_timeout).call(request, env) }

    context 'when timeout' do
      let(:env) { { request: { timeout: 1 } } }

      it 'sets timeout_ms' do
        expect(request.options[:timeout_ms]).to eq(1000)
      end
    end

    context 'when open_timeout' do
      let(:env) { { request: { open_timeout: 1 } } }

      it 'sets connecttimeout_ms' do
        expect(request.options[:connecttimeout_ms]).to eq(1000)
      end
    end
  end

  describe '#configure_proxy' do
    before { adapter.method(:configure_proxy).call(request, env) }

    context 'when proxy' do
      let(:env) { { request: { proxy: { uri: double(scheme: 'http', host: 'localhost', port: '3001') } } } }

      it 'sets proxy' do
        expect(request.options[:proxy]).to eq('http://localhost:3001')
      end

      context 'when username and password' do
        let(:env) do
          { request: { proxy: {
            uri: double(scheme: 'http', host: :a, port: :b),
            user: 'a',
            password: 'b'
          } } }
        end

        it 'sets proxyuserpwd' do
          expect(request.options[:proxyuserpwd]).to eq('a:b')
        end
      end
    end
  end

  describe '#configure_ssl' do
    before { adapter.method(:configure_ssl).call(request, env) }

    context 'when version' do
      let(:env) { { ssl: { version: 'a' } } }

      it 'sets sslversion' do
        expect(request.options[:sslversion]).to eq('a')
      end
    end

    context 'when client_cert' do
      let(:env) { { ssl: { client_cert: 'a' } } }

      it 'sets sslcert' do
        expect(request.options[:sslcert]).to eq('a')
      end
    end

    context 'when client_key' do
      let(:env) { { ssl: { client_key: 'a' } } }

      it 'sets sslkey' do
        expect(request.options[:sslkey]).to eq('a')
      end
    end

    context 'when ca_file' do
      let(:env) { { ssl: { ca_file: 'a' } } }

      it 'sets cainfo' do
        expect(request.options[:cainfo]).to eq('a')
      end
    end

    context 'when ca_path' do
      let(:env) { { ssl: { ca_path: 'a' } } }

      it 'sets capath' do
        expect(request.options[:capath]).to eq('a')
      end
    end

    context 'when client_cert_passwd' do
      let(:env) { { ssl: { client_cert_passwd: 'a' } } }

      it 'sets keypasswd to the value of client_cert_passwd' do
        expect(request.options[:keypasswd]).to eq('a')
      end
    end

    context 'when client_certificate_password' do
      let(:env) { { ssl: { client_certificate_password: 'a' } } }

      it 'sets keypasswd to the value of client_cert_passwd' do
        expect(request.options[:keypasswd]).to eq('a')
      end
    end

    context 'when no client_cert_passwd' do
      let(:env) { { ssl: {} } }

      it 'does not set keypasswd on options' do
        expect(request.options).not_to have_key :keypasswd
      end
    end

    context 'when verify is false' do
      let(:env) { { ssl: { verify: false } } }

      it 'sets ssl_verifyhost to 0' do
        expect(request.options[:ssl_verifyhost]).to eq(0)
      end

      it 'sets ssl_verifypeer to false' do
        expect(request.options[:ssl_verifypeer]).to be_falsey
      end
    end

    context 'when verify is true' do
      let(:env) { { ssl: { verify: true } } }

      it 'sets ssl_verifyhost to 2' do
        expect(request.options[:ssl_verifyhost]).to eq(2)
      end

      it 'sets ssl_verifypeer to true' do
        expect(request.options[:ssl_verifypeer]).to be_truthy
      end
    end
  end

  describe '#parallel?' do
    context 'when parallel_manager' do
      let(:env) { { parallel_manager: true } }

      it 'returns true' do
        expect(adapter.method(:parallel?).call(env)).to be_truthy
      end
    end

    context 'when no parallel_manager' do
      let(:env) { { parallel_manager: nil } }

      it 'returns false' do
        expect(adapter.method(:parallel?).call(env)).to be_falsey
      end
    end
  end

  context 'requests' do
    let(:http_method) { :get }
    let!(:request_stub) { stub_request(http_method, base_url) }

    let(:conn) do
      Faraday.new(url: base_url) do |faraday|
        faraday.adapter :typhoeus
      end
    end

    after do
      expect(request_stub).to have_been_requested unless request_stub.disabled?
    end

    context 'when parallel' do
      it 'returns a faraday response' do
        response = nil
        conn.in_parallel { response = conn.get('/') }
        expect(response).to be_a(Faraday::Response)
      end

      it 'succeeds' do
        response = nil
        conn.in_parallel { response = conn.get('/') }
        expect(response.status).to be(200)
      end
    end

    context 'when not parallel' do
      it 'returns a faraday response' do
        expect(conn.get('/')).to be_a(Faraday::Response)
      end

      it 'succeeds' do
        expect(conn.get('/').status).to be(200)
      end

      it 'sets timings' do
        response = conn.get('/')
        expect(response.env.custom_members[:typhoeus_timings]).to eq({
                                                                       appconnect: 0,
                                                                       connect: 0,
                                                                       namelookup: 0,
                                                                       pretransfer: 0,
                                                                       redirect: 0,
                                                                       starttransfer: 0,
                                                                       total: 0
                                                                     })
      end
    end

    context 'failed connection' do
      before do
        request_stub.to_timeout
      end

      context 'when parallel' do
        it "isn't successful" do
          response = nil
          conn.in_parallel { response = conn.get('/') }
          expect(response.success?).to be_falsey
        end

        it 'translates the response code into an error message' do
          response = nil
          conn.in_parallel { response = conn.get('/') }

          expect(response.env[:typhoeus_timed_out]).to be true
          expect(response.env[:typhoeus_return_message]).to eq('Timeout was reached')
        end
      end

      context 'when not parallel' do
        it 'raises an error' do
          expect { conn.get('/') }.to raise_error(Faraday::TimeoutError, 'Timeout was reached')
        end
      end
    end
  end
end
