module Nominal
  module Operations
    module Update
      def update(body)
        response = Requestor.new.request(:put, self.url, nil, body)
        Util.convert_to_nominal_object(response, self.class_name)
      end
    end
  end
end