module Nominal
  module Operations
    module CustomAction
      def custom_action(method, action=nil, params=nil, body=nil)
        url = action ? [self.url, action].join('/') : self.url
        response = Requestor.new.request(method, url, params, body)
        Util.convert_to_nominal_object(response, self.class_name)
      end
    end
  end
end