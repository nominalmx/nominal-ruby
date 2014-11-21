module Nominal
  module InvoiceAttributes
    class Donee
      include Properties

      has_properties :authorization_number,
                    :authorization_date,
                    :legend

      def to_xml(xml)

        self.version ||= '1.1'

        donation_attr = {}
        donation_attr['xmlns:donat'] = 'http://www.sat.gob.mx/donat'
        donation_attr['xsi:schemaLocation'] = 'http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cdv32.xsd http://www.sat.gob.mx/donat http://www.sat.gob.mx/sitio_internet/cfd/donat/donat11.xsd'
        donation_attr[:version] = self.version
        donation_attr[:noAutorizacion] = self.authorization_number
        donation_attr[:fechaAutorizacion] = self.authorization_date
        donation_attr[:leyenda] = self.legend

        xml['donat'].Donatarias(donation_attr)

        xml

      end

    end
  end
end