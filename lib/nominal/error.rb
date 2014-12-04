module Nominal
  class Error < Exception

    attr_reader :message
    attr_reader :errors
    attr_reader :code

    def initialize(message=nil, errors=nil, code=nil)
      @message = message
      @errors = errors
      @code = code
    end

    def class_name
      self.class.name.split('::')[-1]
    end

    def self.error_handler(resp, code)

      if code == nil or code == 0 or code == nil or code == ""
        raise NoConnectionError.new(resp.to_s)
      end

      if resp.instance_of?(Hash)
        @message = resp["message"] if resp.has_key?('message')
        @errors = resp["errors"] if resp.has_key?('errors')
        @code = code
      end

      case code
        when 400
          raise MalformedRequestError.new(@message, @errors, @code)
        when 401
          raise AuthenticationError.new(@message, @errors, @code)
        when 402
          raise ProcessingError.new(@message, @errors, @code)
        when 404
          raise ResourceNotFoundError.new(@message, @errors, @code)
        when 422
          raise UnprocessableEntityError.new(@message, @errors, @code)
        when 500
          raise ApiError.new(@message, @errors, @code)
        else
          raise Error.new(@message, @errors, @code)
      end

    end

  end

  class ApiError < Error; end
  class NoConnectionError < Error; end
  class AuthenticationError < Error; end
  class UnprocessableEntityError < Error; end
  class ProcessingError < Error; end
  class ResourceNotFoundError < Error; end
  class MalformedRequestError < Error; end

end
