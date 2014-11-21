module Nominal
  module InvoiceAttributes
    class Perceptions
      include Properties

      has_properties :total_taxed,
                     :total_exempt,
                     :perceptions

      def to_xml(xml, precision = 2)

        unless self.perceptions.nil? or !self.perceptions.is_a? Array or self.perceptions.empty?

          perceptions_attr = {
              TotalGravado: MoneyUtils.number_to_rounded_precision(self.total_taxed, precision),
              TotalExento: MoneyUtils.number_to_rounded_precision(self.total_exempt, precision)
          }

          xml.Percepciones(perceptions_attr){
            self.perceptions.each {|perception| perception.to_xml(xml, precision) }
          }

        end

        xml

      end

    end

    class Perception
      include Properties

      has_properties :perception_type,
                     :key,
                     :concept,
                     :taxed_amount,
                     :exempt_amount

      def to_xml(xml, precision = 2)

        xml.Percepcion({
                           TipoPercepcion: self.perception_type,
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