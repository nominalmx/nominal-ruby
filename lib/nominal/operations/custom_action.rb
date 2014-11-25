module Nominal
  module Operations
    module CustomAction
      def custom_action(method, action=nil, params=nil)
        url = action ? [self.url, action].join('/') : self.url
        response = Requestor.new.request(method, url, params)
        Util.convert_to_nominal_object(response, self.class_name)
      end
    end
  end
end