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
      api_base = Nominal.api_base
      api_base + url
    end

    def request(method, url, params=nil, body=nil)

      url = self.api_url(url)
      meth = method.downcase

      begin
        conn = Faraday.new(url: url) do |faraday|
          faraday.adapter Faraday.default_adapter
        end

        conn.headers['Authorization'] = get_token
        conn.headers['x-nominal-time'] = self.time.to_s
        conn.headers['Accept'] = MIME::Types['application/json']
        conn.headers['Content-Type'] = MIME::Types['application/json']

        conn.params = params unless params.nil?

        response = if body.nil?
                     conn.method(meth).call
                   else
                     # post payload as JSON
                     json = JSON.generate(body)
                     conn.post { |req| req.body = json}
                   end

      rescue Exception => e
        Error.error_handler(e, "")
      end

      p response.inspect

      if response.status != 200
        Error.error_handler(JSON.parse(response.body), response.status)
      end

      JSON.parse(response.body)

    end

    private
    def get_token
      signature = OpenSSL::HMAC.hexdigest('sha256', self.private_api_key, time.to_s)
      "Nominal #{self.public_api_key}:#{signature}"
    end

  end

end