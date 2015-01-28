require 'spec_helper'

describe Nominal::InvoiceXmlData do

  let!(:key) do
    root = File.expand_path "../..", __FILE__
    key_path = File.join(root, 'fixtures', 'AAD990814BP7.key').to_s
    Nominal::InvoiceUtils::Key.new key_path, "12345678a"
  end

  let!(:cert) do
    root = File.expand_path "../..", __FILE__
    path = File.join(root, 'fixtures', 'AAD990814BP7.cer').to_s
    Nominal::InvoiceUtils::Certificate.new path
  end

  subject(:invoice_data) do

    fiscal_address = Nominal::InvoiceAttributes::FiscalAddress.new({
                                                                       street: "GABRIEL TEPEPA",
                                                                       exterior_number: "19",
                                                                       neighborhood: "COLORINES",
                                                                       locality: "Cuautla",
                                                                       municipality: "Cuautla",
                                                                       municipality: "Morelos",
                                                                       state: "Morelos",
                                                                       country: "México",
                                                                       postal_code: "64743"
                                                                   })

    issuer = Nominal::InvoiceAttributes::Issuer.new({
                                                        rfc: "AAD990814BP7",
                                                        name: "Empresa de Victor",
                                                        fiscal_regime: 0,
                                                        fiscal_address: fiscal_address
                                                    })


    receptor = Nominal::InvoiceAttributes::Receptor.new({
                                                            rfc: "AAD990814BP7",
                                                            name: "Empresa de Victor",
                                                        })

    withholding = Nominal::InvoiceAttributes::Withholding.new({
                                                                  tax_text: "IVA",
                                                                  rate: 16.000000,
                                                                  amount: 50.36
                                                              })

    tax = Nominal::InvoiceAttributes::Tax.new({
                                                  total_taxes_withheld: 50.36,
                                                  total_taxes_transferred: 0,
                                                  withholdings: [withholding]
                                              })

    concept = Nominal::InvoiceAttributes::Concept.new({
                                                          quantity: 4,
                                                          unit: "N/A",
                                                          description: "Juguete",
                                                          unit_value: 16.00,
                                                          amount: 4,
                                                      })


    invoice_data = Nominal::InvoiceXmlData.new({
                                                   folio: 10,
                                                   expedition_date: Date.new(2014, 7, 10),
                                                   subtotal: 16.000000,
                                                   total: 18.5600000,
                                                   payment_form: "PAGO EN UNA SOLA EXHIBICIÓN",
                                                   payment_method: "EFECTIVO",
                                                   currency: "MXN",
                                                   expedition_place: "YUCATÁN, MÉXICO",
                                                   issuer: issuer,
                                                   receptor: receptor,
                                                   invoice_type: 0,
                                                   api_reference: "ksdfkkasdfalsdfasdfl",
                                                   public_id: "0934039302440",
                                                   status: 2,
                                                   voucher_type_text: "egreso",
                                                   environment: 1,
                                                   fiscal_regime: "RÉGIMEN GENERAL DE LEY PERSONAS MORALES",
                                                   supplier: 1,
                                                   precision: 2,
                                                   concepts: [concept],
                                                   tax: tax
                                               })

    invoice_data

  end

  it "can be XML marshalled" do
    xml = invoice_data.to_xml
    expect(xml).to eq("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<cfdi:Comprobante xmlns:cfdi=\"http://www.sat.gob.mx/cfd/3\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd\" version=\"3.2\" fecha=\"2014-07-10T00:00:00\" sello=\"\" formaDePago=\"PAGO EN UNA SOLA EXHIBICIÓN\" noCertificado=\"\" certificado=\"\" subTotal=\"16.0\" total=\"18.56\" metodoDePago=\"EFECTIVO\" tipoDeComprobante=\"egreso\" LugarExpedicion=\"YUCATÁN, MÉXICO\" folio=\"10\" Moneda=\"MXN\">\n  <cfdi:Emisor rfc=\"AAD990814BP7\" nombre=\"Empresa de Victor\">\n    <cfdi:DomicilioFiscal pais=\"México\" calle=\"GABRIEL TEPEPA\" municipio=\"Morelos\" estado=\"Morelos\" noExterior=\"19\" colonia=\"COLORINES\" localidad=\"Cuautla\" codigoPostal=\"64743\"/>\n    <cfdi:RegimenFiscal Regimen=\"0\"/>\n  </cfdi:Emisor>\n  <cfdi:Receptor rfc=\"AAD990814BP7\" nombre=\"Empresa de Victor\"/>\n  <cfdi:Conceptos>\n    <cfdi:Concepto cantidad=\"4\" unidad=\"N/A\" descripcion=\"Juguete\" valorUnitario=\"16.0\" importe=\"4\"/>\n  </cfdi:Conceptos>\n  <cfdi:Impuestos totalImpuestosRetenidos=\"50.36\" totalImpuestosTrasladados=\"0\">\n    <cfdi:Retenciones>\n      <cfdi:Retencion impuesto=\"IVA\" importe=\"50.36\"/>\n    </cfdi:Retenciones>\n  </cfdi:Impuestos>\n</cfdi:Comprobante>\n")
  end

  it "can be validated" do

    invoice_data.certificate_data = cert.data
    invoice_data.certificate_number = cert.certificate_number
    pre_sealed_xml = invoice_data.to_xml
    invoice_data.seal = key.seal(pre_sealed_xml)
    xml = invoice_data.to_xml.gsub(/\n/, '')

    errors = Nominal::InvoiceUtils::SchemaValidator.validate_xml xml

    expect(errors).to be_empty

    errors.each { |error| p error.to_s }


  end

  it "can be sealed" do

    invoice_data.certificate_data = cert.data
    invoice_data.certificate_number = cert.certificate_number
    pre_sealed_xml = invoice_data.to_xml
    invoice_data.seal = key.seal(pre_sealed_xml)
    xml = invoice_data.to_xml.gsub(/\n/, '')

    expect(xml).to eq("<?xml version=\"1.0\" encoding=\"utf-8\"?><cfdi:Comprobante xmlns:cfdi=\"http://www.sat.gob.mx/cfd/3\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd\" version=\"3.2\" fecha=\"2014-07-10T00:00:00\" sello=\"Zqf3zDqKByKIIOLDzjX5CXIsnsHRDCDIGGxGeaHPFHJVF70eRK7hEXn2n8ZbR7qLuvneWo75eZcNbUvTTKGuTbZdIHPyBXWjuaNI+56fZYF6bYc7Mc2oGBsjx13RrqL7dohiuqaJnr7gRXkqq5RdVSmgwdynItXHXoBz8tGDGXM=\" formaDePago=\"PAGO EN UNA SOLA EXHIBICIÓN\" noCertificado=\"20001000000200000293\" certificado=\"MIIE2jCCA8KgAwIBAgIUMjAwMDEwMDAwMDAyMDAwMDAyOTMwDQYJKoZIhvcNAQEFBQAwggFcMRowGAYDVQQDDBFBLkMuIDIgZGUgcHJ1ZWJhczEvMC0GA1UECgwmU2VydmljaW8gZGUgQWRtaW5pc3RyYWNpw7NuIFRyaWJ1dGFyaWExODA2BgNVBAsML0FkbWluaXN0cmFjacOzbiBkZSBTZWd1cmlkYWQgZGUgbGEgSW5mb3JtYWNpw7NuMSkwJwYJKoZIhvcNAQkBFhphc2lzbmV0QHBydWViYXMuc2F0LmdvYi5teDEmMCQGA1UECQwdQXYuIEhpZGFsZ28gNzcsIENvbC4gR3VlcnJlcm8xDjAMBgNVBBEMBTA2MzAwMQswCQYDVQQGEwJNWDEZMBcGA1UECAwQRGlzdHJpdG8gRmVkZXJhbDESMBAGA1UEBwwJQ295b2Fjw6FuMTQwMgYJKoZIhvcNAQkCDCVSZXNwb25zYWJsZTogQXJhY2VsaSBHYW5kYXJhIEJhdXRpc3RhMB4XDTEyMTAyNjE5MjI0M1oXDTE2MTAyNjE5MjI0M1owggFTMUkwRwYDVQQDE0BBU09DSUFDSU9OIERFIEFHUklDVUxUT1JFUyBERUwgRElTVFJJVE8gREUgUklFR08gMDA0IERPTiBNQVJUSU4gMWEwXwYDVQQpE1hBU09DSUFDSU9OIERFIEFHUklDVUxUT1JFUyBERUwgRElTVFJJVE8gREUgUklFR08gMDA0IERPTiBNQVJUSU4gQ09BSFVJTEEgWSBOVUVWTyBMRU9OIEFDMUkwRwYDVQQKE0BBU09DSUFDSU9OIERFIEFHUklDVUxUT1JFUyBERUwgRElTVFJJVE8gREUgUklFR08gMDA0IERPTiBNQVJUSU4gMSUwIwYDVQQtExxBQUQ5OTA4MTRCUDcgLyBIRUdUNzYxMDAzNFMyMR4wHAYDVQQFExUgLyBIRUdUNzYxMDAzTURGUk5OMDkxETAPBgNVBAsTCFNlcnZpZG9yMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDlrI9loozd+UcW7YHtqJimQjzX9wHIUcc1KZyBBB8/5fZsgZ/smWS4Sd6HnPs9GSTtnTmM4bEgx28N3ulUshaaBEtZo3tsjwkBV/yVQ3SRyMDkqBA2NEjbcum+e/MdCMHiPI1eSGHEpdESt55a0S6N24PW732Xm3ZbGgOp1tht1wIDAQABox0wGzAMBgNVHRMBAf8EAjAAMAsGA1UdDwQEAwIGwDANBgkqhkiG9w0BAQUFAAOCAQEAuoPXe+BBIrmJn+IGeI+m97OlP3RC4Ct3amjGmZICbvhI9BTBLCL/PzQjjWBwU0MG8uK6e/gcB9f+klPiXhQTeI1YKzFtWrzctpNEJYo0KXMgvDiputKphQ324dP0nzkKUfXlRIzScJJCSgRw9ZifKWN0D9qTdkNkjk83ToPgwnldg5lzU62woXo4AKbcuabAYOVoC7owM5bfNuWJe566UzD6i5PFY15jYMzi1+ICriDItCv3S+JdqyrBrX3RloZhdyXqs2Htxfw4b1OcYboPCu4+9qM3OV02wyGKlGQMhfrXNwYyj8huxS1pHghEROM2Zs0paZUOy+6ajM+Xh0LX2w==\" subTotal=\"16.0\" total=\"18.56\" metodoDePago=\"EFECTIVO\" tipoDeComprobante=\"egreso\" LugarExpedicion=\"YUCATÁN, MÉXICO\" folio=\"10\" Moneda=\"MXN\">  <cfdi:Emisor rfc=\"AAD990814BP7\" nombre=\"Empresa de Victor\">    <cfdi:DomicilioFiscal pais=\"México\" calle=\"GABRIEL TEPEPA\" municipio=\"Morelos\" estado=\"Morelos\" noExterior=\"19\" colonia=\"COLORINES\" localidad=\"Cuautla\" codigoPostal=\"64743\"/>    <cfdi:RegimenFiscal Regimen=\"0\"/>  </cfdi:Emisor>  <cfdi:Receptor rfc=\"AAD990814BP7\" nombre=\"Empresa de Victor\"/>  <cfdi:Conceptos>    <cfdi:Concepto cantidad=\"4\" unidad=\"N/A\" descripcion=\"Juguete\" valorUnitario=\"16.0\" importe=\"4\"/>  </cfdi:Conceptos>  <cfdi:Impuestos totalImpuestosRetenidos=\"50.36\" totalImpuestosTrasladados=\"0\">    <cfdi:Retenciones>      <cfdi:Retencion impuesto=\"IVA\" importe=\"50.36\"/>    </cfdi:Retenciones>  </cfdi:Impuestos></cfdi:Comprobante>")

  end

end