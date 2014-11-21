module Nominal
  module InvoiceAttributes
    class Transfer
      include Properties

      has_properties :tax_text,
                     :rate,
                     :amount

      def to_xml(xml, precision = 2)

        xml.Traslado({
                         impuesto: self.tax_text,
                         tasa: self.rate,
                         importe: MoneyUtils.number_to_rounded_precision(self.amount, precision)
                     })

        xml

      end

    end
  end
end