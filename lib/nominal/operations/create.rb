module Nominal
  module Operations
    module Create
      module ClassMethods
        def create(body)
          url = self.url
          response = Requestor.new.request(:post, url, nil, body)
          Util.convert_to_nominal_object(response, self.class_name)
        end
      end
      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
