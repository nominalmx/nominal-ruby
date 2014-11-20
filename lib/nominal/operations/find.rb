module Nominal
  module Operations
    module Find
      module ClassMethods
        def find(id)
          instance = self.new(id)
          response = Requestor.new.request(:get, instance.url)
          Util.convert_to_nominal_object(response, instance.class_name)
        end
      end
      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
