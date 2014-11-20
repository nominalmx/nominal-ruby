module Nominal
  module Util

    def self.object_classes
      @object_classes ||= {
          # business objects
          'invoice' => Invoice
      }
    end

    def self.convert_to_nominal_object(resp, name)
      case resp
        when Array
          resp.map { |i| convert_to_nominal_object(i, name) }
        when Hash
          # Try converting to a known object class.  If none available, fall back to generic NominalObject
          object_classes.fetch(name, NominalObject).construct_from(resp)
        else
          resp
      end
    end

  end
end
