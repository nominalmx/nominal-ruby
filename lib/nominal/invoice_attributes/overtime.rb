module Nominal
  module InvoiceAttributes
    class Overtime
      include Properties

      has_properties :days,
                     :type_hours_text,
                     :overtime_amount,
                     :amount

      def to_xml(xml, precision = 2)

        xml.HorasExtra({
                           Dias: self.days,
                           TipoHoras: self.type_hours_text,
                           HorasExtra: self.overtime_amount,
                           ImportePagado: MoneyUtils.number_to_rounded_precision(self.amount, precision)
                       })

        xml

      end

    end
  end
end