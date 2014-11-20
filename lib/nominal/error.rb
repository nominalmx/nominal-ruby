module Nominal
  class Error < Exception
    attr_reader :message
    attr_reader :message_to_purchaser
    attr_reader :type
    attr_reader :code
    attr_reader :param

    def initialize(message=nil, message_to_purchaser=nil, type=nil, code=nil, param=nil)
      @message = message
      @message_to_purchaser = message_to_purchaser
      @type = type
      @code = code
      @param = param
    end
    def class_name
      self.class.name.split('::')[-1]
    end
    def self.error_handler(resp, code)
      if resp.instance_of?(Hash)
        @message = resp["message"] if resp.has_key?('message')
        @message_to_purchaser = resp["message_to_purchaser"] if resp.has_key?('message_to_purchaser')
        @type = resp["type"] if resp.has_key?('type')
        @code = resp["code"] if resp.has_key?('code')
        @param = resp["param"] if resp.has_key?('param')
      end
      if code == nil or code == 0 or code == nil or code == ""
        raise NoConnectionError.new(resp.to_s)
      end
      case code
        when 400
          raise MalformedRequestError.new(@message, @message_to_purchaser, @type, @code, @params)
        when 401
          raise AuthenticationError.new(@message, @message_to_purchaser, @type, @code, @params)
        when 402
          raise ProcessingError.new(@message, @message_to_purchaser, @type, @code, @params)
        when 404
          raise ResourceNotFoundError.new(@message, @message_to_purchaser, @type, @code, @params)
        when 422
          raise ParameterValidationError.new(@message, @message_to_purchaser, @type, @code, @params)
        when 500
          raise ApiError.new(@message, @message_to_purchaser, @type, @code, @params)
        else
          raise Error.new(@message, @message_to_purchaser, @type, @code, @params)
      end
    end
  end
  class ApiError < Error
  end

  class NoConnectionError < Error
  end

  class AuthenticationError < Error
  end

  class ParameterValidationError < Error
  end

  class ProcessingError < Error
  end

  class ResourceNotFoundError < Error
  end

  class MalformedRequestError < Error
  end
end
