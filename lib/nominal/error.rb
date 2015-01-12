module Nominal

  class NominalApiError < Exception

    attr_reader :message
    attr_reader :status
    attr_reader :code

    def initialize(status=nil, message=nil, code=nil)
      @status = status
      @message = message
      @code = code
    end

    def inspect
      "#<#{self.class}:0x#{self.object_id.to_s(16)}" + " status: #{status}, message: #{message}, code: #{code}"
    end

    def self.error_handler(resp, code)

      if code == nil or code == 0 or code == nil or code == ""
        raise NoConnectionError.new(resp.to_s)
      end

      if resp.instance_of?(Hash)
        @status = resp["status"] if resp.has_key?('status')
        @message = resp["message"] if resp.has_key?('message')
        @code = resp["code"] if resp.has_key?('code')
      end

      raise NominalApiError.new(@status, @message, @code)

    end

  end

  class ApiError < NominalApiError; end
  class NoConnectionError < NominalApiError; end
  class AuthenticationError < NominalApiError; end
  class UnprocessableEntityError < NominalApiError; end
  class ProcessingError < NominalApiError; end
  class ResourceNotFoundError < NominalApiError; end
  class MalformedRequestError < NominalApiError; end



end
