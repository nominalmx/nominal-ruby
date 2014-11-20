require 'spec_helper'

describe Nominal::Invoice do

  describe Nominal::InvoiceAttributes::Concept do

    subject(:concept) { Nominal::InvoiceAttributes::Concept.new({
                                                                    quantity: 4.0000,
                                                                    unit: 4,
                                                                    description: 4,
                                                                    unit_value: 4.0000,
                                                                    amount: 16.0000})
    }

    it "can be XML marshalled" do

      builder = Nokogiri::XML::Builder.new do |xml|
        xml.Conceptos {
          concept.to_xml(xml)
        }
      end

      xml = builder.to_xml
      expect(xml).to eq("<?xml version=\"1.0\"?>\n<Conceptos>\n  <Concepto cantidad=\"4.0\" unidad=\"4\" descripcion=\"4\" valorUnitario=\"0.4E1\" importe=\"0.16E2\"/>\n</Conceptos>\n")

    end

  end

  describe Nominal::InvoiceAttributes::Issuer do

    subject(:issuer) do

      fiscal_address = Nominal::InvoiceAttributes::FiscalAddress.new({
                                                                         street: "GABRIEL TEPEPA",
                                                                         exterior_number: "19",
                                                                         neighborhood: "COLORINES",
                                                                         locality: "Cuautla",
                                                                         municipality: "Cuautla",
                                                                         municipality: "Morelos",
                                                                         country: "México",
                                                                         postal_code: "64743"
                                                                     })


      issuer = Nominal::InvoiceAttributes::Issuer.new({
                                                          rfc: "AAD990814BP7",
                                                          name: "Empresa de Victor",
                                                          fiscal_regime: 0,
                                                          fiscal_address: fiscal_address
                                                      })

      issuer

    end

    it "can be XML marshalled" do

      builder = Nokogiri::XML::Builder.new do |xml|
        xml.Comprobante do
          xml.doc.root.namespace = xml.doc.root.add_namespace_definition('cfdi', 'http://www.sat.gob.mx/cfd/3')
          issuer.to_xml(xml)
        end
      end

      xml = builder.to_xml

      expect(xml).to eq("<?xml version=\"1.0\"?>\n<cfdi:Comprobante xmlns:cfdi=\"http://www.sat.gob.mx/cfd/3\">\n  <cfdi:Emisor rfc=\"AAD990814BP7\" nombre=\"Empresa de Victor\">\n    <cfdi:DomicilioFiscal pais=\"M&#xE9;xico\" calle=\"GABRIEL TEPEPA\" municipio=\"Morelos\" noExterior=\"19\" colonia=\"COLORINES\" localidad=\"Cuautla\" codigoPostal=\"64743\"/>\n    <cfdi:RegimenFiscal Regimen=\"0\"/>\n  </cfdi:Emisor>\n</cfdi:Comprobante>\n")

    end

  end

  describe Nominal::InvoiceAttributes::Receptor do

    subject(:receptor) do

      fiscal_address = Nominal::InvoiceAttributes::FiscalAddress.new({
                                                                         street: "GABRIEL TEPEPA",
                                                                         exterior_number: "19",
                                                                         neighborhood: "COLORINES",
                                                                         locality: "Cuautla",
                                                                         municipality: "Cuautla",
                                                                         municipality: "Morelos",
                                                                         country: "México",
                                                                         postal_code: "64743"
                                                                     })


      receptor = Nominal::InvoiceAttributes::Receptor.new({
                                                              rfc: "AAD990814BP7",
                                                              name: "Empresa de Victor",
                                                              receptor_address: fiscal_address
                                                          })

      receptor

    end

    it "can be XML marshalled" do

      builder = Nokogiri::XML::Builder.new do |xml|
        xml.Comprobante do
          xml.doc.root.namespace = xml.doc.root.add_namespace_definition('cfdi', 'http://www.sat.gob.mx/cfd/3')
          receptor.to_xml(xml)
        end
      end

      xml = builder.to_xml

      expect(xml).to eq("<?xml version=\"1.0\"?>\n<cfdi:Comprobante xmlns:cfdi=\"http://www.sat.gob.mx/cfd/3\">\n  <cfdi:Receptor rfc=\"AAD990814BP7\" nombre=\"Empresa de Victor\">\n    <cfdi:DomicilioFiscal pais=\"M&#xE9;xico\" calle=\"GABRIEL TEPEPA\" municipio=\"Morelos\" noExterior=\"19\" colonia=\"COLORINES\" localidad=\"Cuautla\" codigoPostal=\"64743\"/>\n  </cfdi:Receptor>\n</cfdi:Comprobante>\n")

    end

  end

end