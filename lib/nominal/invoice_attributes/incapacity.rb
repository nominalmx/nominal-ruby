module Nominal
  module InvoiceAttributes
    class Incapacity
      include Properties

      has_properties :incapacity_days,
                     :incapacity_type_value,
                     :discount

      def to_xml(xml, precision = 2)

        xml.Incapacidad({
                            DiasIncapacidad: self.incapacity_days,
                            TipoIncapacidad: self.incapacity_type_value,
                            Descuento: MoneyUtils.number_to_rounded_precision(self.discount, precision)
                        })

        xml

      end

    end
  end
end