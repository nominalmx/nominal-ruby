module Nominal
  module InvoiceAttributes
    class Tax
      include Properties

      has_properties :total_taxes_withheld,
                     :total_taxes_transferred,
                     :withholdings,
                     :transfers

      def to_xml(xml, precision = 2)

        tax_attr = {}

        unless self.total_taxes_withheld.nil?
            tax_attr[:totalImpuestosRetenidos] = MoneyUtils.number_to_rounded_precision(self.total_taxes_withheld, precision)
        end

        unless self.total_taxes_transferred.nil?
            tax_attr[:totalImpuestosTrasladados] = MoneyUtils.number_to_rounded_precision(self.total_taxes_transferred, precision)
        end

        xml.Impuestos(tax_attr) {
          unless self.withholdings.nil? or !self.withholdings.is_a? Array or self.withholdings.empty?
            xml.Retenciones() {
              self.withholdings.each do |withholding|
                withholding.to_xml(xml, precision)
              end
            }
          end
          unless self.transfers.nil? or !self.transfers.is_a? Array or self.transfers.empty?
            xml.Traslados() {
              self.transfers.each do |transfer|
                transfer.to_xml(xml, precision)
              end
            }
          end
        }

        xml

      end

    end
  end
end