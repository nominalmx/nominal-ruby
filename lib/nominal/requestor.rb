require 'faraday'
require 'base64'
require 'mime/types'

module Nominal

  class Requestor

    attr_reader :private_api_key
    attr_reader :public_api_key
    attr_reader :time

    def initialize
      @private_api_key = Nominal.private_api_key
      @public_api_key = Nominal.public_api_key
      @time = Time.now.utc.to_i
    end

    def api_url(url='')
      #api_base = Nominal.api_base
      api_base = "http://api.nominal.mx"
      api_base + url
    end

    def request(method, url, params=nil, body=nil)

      url = self.api_url(url)
      meth = method.downcase


      begin

        #connection = Faraday.new url, :ssl => false

        conn = Faraday.new(url: url) do |faraday|
          faraday.adapter Faraday.default_adapter
        end

        conn.headers['Authorization'] = get_token
        conn.headers['x-nominal-time'] = self.time.to_s
        conn.headers['Accept'] = MIME::Types['application/json']
        conn.headers['Content-Type'] = MIME::Types['application/json']

        conn.params = params unless params.nil?

        response = conn.method(meth).call do |req|
          req.body = JSON.generate(body) unless body.nil?
        end

      rescue Exception => e
        NominalApiError.error_handler(e, "")
      end

      json = JSON.parse(response.body)

      if response_its_error? json
        NominalApiError.error_handler(JSON.parse(response.body), response.status)
      end

      json

    end

    private
    def response_its_error? json
      return true if json.nil?
      json['status'] == "ERROR"
    end

    def get_token
      signature = OpenSSL::HMAC.hexdigest('sha256', self.private_api_key, time.to_s)
      "Nominal #{self.public_api_key}:#{signature}"
    end

  end

end