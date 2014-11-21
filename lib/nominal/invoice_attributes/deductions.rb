module Nominal
  module InvoiceAttributes
    class Deductions
      include Properties

      has_properties :total_taxed,
                     :total_exempt,
                     :deductions

      def to_xml(xml, precision = 2)

        unless self.deductions.nil? or !self.deductions.is_a? Array or self.deductions.empty?

          deductions_attr = {
              TotalGravado: MoneyUtils.number_to_rounded_precision(self.total_taxed, precision),
              TotalExento: MoneyUtils.number_to_rounded_precision(self.total_exempt, precision)
          }

          xml.Percepciones(deductions_attr){
            self.deductions.each {|deduction| deduction.to_xml(xml, precision) }
          }

        end

        xml

      end

    end

    class Deduction
      include Properties

      has_properties :deduction_type,
                     :key,
                     :concept,
                     :taxed_amount,
                     :exempt_amount

      def to_xml(xml, precision = 2)

        xml.Percepcion({
                           TipoPercepcion: self.deduction_type,
                           Clave: self.key,
                           Concepto: self.concept,
                           ImporteGravado: MoneyUtils.number_to_rounded_precision(self.taxed_amount, precision),
                           ImporteExento: MoneyUtils.number_to_rounded_precision(self.exempt_amount, precision)
                       })

        xml

      end

    end

  end
end