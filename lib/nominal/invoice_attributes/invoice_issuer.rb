module Nominal
  module InvoiceAttributes

    class InvoiceIssuer
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
          fiscal_address.to_xml(xml) unless fiscal_address.nil?
          issued_address.to_xml(xml) unless issued_address.nil?
          xml.RegimenFiscal({
                                Regimen: fiscal_regime
                            })
        }

        xml

      end

    end

  end
end