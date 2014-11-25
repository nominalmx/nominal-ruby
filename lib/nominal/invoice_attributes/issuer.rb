module Nominal
  module InvoiceAttributes

    class Issuer
      include Properties

      has_properties :rfc,
                    :name,
                    :fiscal_regime,
                    :fiscal_address,
                    :issued_address

      def to_xml(xml)
        emisor_attr = {}
        emisor_attr[:rfc] = self.rfc
        emisor_attr[:nombre] = self.name unless self.name.nil?
        xml.Emisor(emisor_attr) {
          self.fiscal_address.to_xml(xml) unless self.fiscal_address.nil?
          self.issued_address.to_xml(xml) unless self.issued_address.nil?
          xml.RegimenFiscal({
                                Regimen: self.fiscal_regime
                            })
        }

        xml

      end

    end

  end
end