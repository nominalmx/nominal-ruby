module Nominal
  module Operations
    module CustomAction
      module ClassMethods
        def custom_action(method, action=nil, params=nil)
          url = action ? [self.url, action].join('/') : self.url
          response = Requestor.new.request(method, url, params)
          Util.convert_to_nominal_object(response, instance.class_name)
        end
      end
      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
