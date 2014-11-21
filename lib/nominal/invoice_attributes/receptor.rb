module Nominal
  module InvoiceAttributes

    class Receptor
      include Properties

      has_properties :rfc,
                     :name,
                     :receptor_address

      def to_xml(xml)

        receptor_attr = {}
        receptor_attr[:rfc] = self.rfc unless self.rfc.nil?
        receptor_attr[:nombre] = self.name unless self.name.nil?

        xml.Receptor(receptor_attr) {
          receptor_address.to_xml(xml) unless receptor_address.nil?
        }

        xml

      end

    end

  end
end