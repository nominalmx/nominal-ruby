module Nominal
  module InvoiceAttributes
    class Withholding
      include Properties

      has_properties :tax_text,
                     :amount

      def to_xml(xml, precision = 2)

        xml.Retencion({
                          impuesto: self.tax_text,
                          importe: MoneyUtils.number_to_rounded_precision(self.amount, precision)
                      })

        xml

      end

    end
  end
end