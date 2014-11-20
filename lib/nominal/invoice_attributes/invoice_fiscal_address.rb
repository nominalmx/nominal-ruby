module Nominal
  module InvoiceAttributes

    class InvoiceFiscalAddress
      include Properties

      has_properties :country,
                    :street,
                    :municipality,
                    :state,
                    :exterior_number,
                    :interior_number,
                    :neighborhood,
                    :locality,
                    :reference,
                    :postal_code

      def to_xml(xml)
        address_attr = {}
        address_attr[:pais] = self.country unless self.country.nil?
        address_attr[:calle] = self.street unless self.street.nil?
        address_attr[:municipio]= self.municipality unless self.municipality.nil?
        address_attr[:estado] = self.state unless self.state.nil?
        address_attr[:noExterior] = self.exterior_number unless self.exterior_number.nil?
        address_attr[:noInterior] = self.interior_number unless self.interior_number.nil?
        address_attr[:colonia] = self.neighborhood unless self.neighborhood.nil?
        address_attr[:localidad] = self.locality unless self.locality.nil?
        address_attr[:referencia] = self.reference unless self.reference.nil?
        address_attr[:codigoPostal] = self.postal_code unless self.postal_code.nil?

        xml.DomicilioFiscal(address_attr)

        xml

      end

    end

  end
end