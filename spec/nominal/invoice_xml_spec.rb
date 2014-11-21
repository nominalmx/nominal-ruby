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
                                                                       country: "México",
                                                                       postal_code: "64743"
                                                                   })

    issuer = Nominal::InvoiceAttributes::Issuer.new({
                                                        rfc: "AAD990814BP7",
                                                        name: "Empresa de Victor",
                                                        fiscal_regime: 0,
                                                        fiscal_address: fiscal_address
                                                    })


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
                                    voucher_type: 0,
                                    mode: 0,
                                    environment: 1,
                                    fiscal_regime: "RÉGIMEN GENERAL DE LEY PERSONAS MORALES",
                                    supplier: 1,
                                    precision: 2
                                })

    invoice_data

  end

  it "can be XML marshalled" do
    xml = invoice_data.to_xml
    expect(xml).to eq("<?xml version=\"1.0\"?>\n<cfdi:Comprobante xmlns:cfdi=\"http://www.sat.gob.mx/cfd/3\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd\" version=\"3.2\" fecha=\"2014-07-10T00:00:00\" sello=\"\" formaDePago=\"PAGO EN UNA SOLA EXHIBICI&#xD3;N\" noCertificado=\"\" certificado=\"\" subTotal=\"0.16E2\" total=\"0.19E2\" metodoDePago=\"EFECTIVO\" LugarExpedicion=\"YUCAT&#xC1;N, M&#xC9;XICO\" folio=\"10\" Moneda=\"MXN\">\n  <cfdi:Emisor rfc=\"AAD990814BP7\" nombre=\"Empresa de Victor\">\n    <cfdi:DomicilioFiscal pais=\"M&#xE9;xico\" calle=\"GABRIEL TEPEPA\" municipio=\"Morelos\" noExterior=\"19\" colonia=\"COLORINES\" localidad=\"Cuautla\" codigoPostal=\"64743\"/>\n    <cfdi:RegimenFiscal Regimen=\"0\"/>\n  </cfdi:Emisor>\n  <cfdi:Receptor rfc=\"AAD990814BP7\" nombre=\"Empresa de Victor\">\n    <cfdi:DomicilioFiscal pais=\"M&#xE9;xico\" calle=\"GABRIEL TEPEPA\" municipio=\"Morelos\" noExterior=\"19\" colonia=\"COLORINES\" localidad=\"Cuautla\" codigoPostal=\"64743\"/>\n  </cfdi:Receptor>\n</cfdi:Comprobante>\n")
  end

  it "can be validated" do

    invoice_data.certificate_data = cert.data
    invoice_data.certificate_number = cert.certificate_number
    pre_sealed_xml = invoice_data.to_xml
    invoice_data.seal = key.seal(pre_sealed_xml)
    xml = invoice_data.to_xml.gsub(/\n/, '')

    #errors = Nominal::InvoiceUtils::SchemaValidator.validate_xml xml

    #errors.each { |error| p error.to_s }

    #expect(errors).to be_empty

  end

  it "can be sealed" do

    invoice_data.certificate_data = cert.data
    invoice_data.certificate_number = cert.certificate_number
    pre_sealed_xml = invoice_data.to_xml
    invoice_data.seal = key.seal(pre_sealed_xml)
    xml = invoice_data.to_xml.gsub(/\n/, '')

    expect(xml).to eq("<?xml version=\"1.0\"?><cfdi:Comprobante xmlns:cfdi=\"http://www.sat.gob.mx/cfd/3\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd\" version=\"3.2\" fecha=\"2014-07-10T00:00:00\" sello=\"GrboqNGWqpMVJrfBROjcBl/CDmqTaIn5N4XfAO7MqPjlyf53a9wTRPD72kW5ICodFjDDo+r9Bgn3iryQ3DLwHl1y39tajnAqRNKLTPu8crVOGHwLScCZJADVz1QoqAcYWWU17Z/28c1VpKa9VLZU+OFJQtwWUXe6J7VuJOoUB64=\" formaDePago=\"PAGO EN UNA SOLA EXHIBICI&#xD3;N\" noCertificado=\"20001000000200000293\" certificado=\"MIIE2jCCA8KgAwIBAgIUMjAwMDEwMDAwMDAyMDAwMDAyOTMwDQYJKoZIhvcNAQEFBQAwggFcMRowGAYDVQQDDBFBLkMuIDIgZGUgcHJ1ZWJhczEvMC0GA1UECgwmU2VydmljaW8gZGUgQWRtaW5pc3RyYWNpw7NuIFRyaWJ1dGFyaWExODA2BgNVBAsML0FkbWluaXN0cmFjacOzbiBkZSBTZWd1cmlkYWQgZGUgbGEgSW5mb3JtYWNpw7NuMSkwJwYJKoZIhvcNAQkBFhphc2lzbmV0QHBydWViYXMuc2F0LmdvYi5teDEmMCQGA1UECQwdQXYuIEhpZGFsZ28gNzcsIENvbC4gR3VlcnJlcm8xDjAMBgNVBBEMBTA2MzAwMQswCQYDVQQGEwJNWDEZMBcGA1UECAwQRGlzdHJpdG8gRmVkZXJhbDESMBAGA1UEBwwJQ295b2Fjw6FuMTQwMgYJKoZIhvcNAQkCDCVSZXNwb25zYWJsZTogQXJhY2VsaSBHYW5kYXJhIEJhdXRpc3RhMB4XDTEyMTAyNjE5MjI0M1oXDTE2MTAyNjE5MjI0M1owggFTMUkwRwYDVQQDE0BBU09DSUFDSU9OIERFIEFHUklDVUxUT1JFUyBERUwgRElTVFJJVE8gREUgUklFR08gMDA0IERPTiBNQVJUSU4gMWEwXwYDVQQpE1hBU09DSUFDSU9OIERFIEFHUklDVUxUT1JFUyBERUwgRElTVFJJVE8gREUgUklFR08gMDA0IERPTiBNQVJUSU4gQ09BSFVJTEEgWSBOVUVWTyBMRU9OIEFDMUkwRwYDVQQKE0BBU09DSUFDSU9OIERFIEFHUklDVUxUT1JFUyBERUwgRElTVFJJVE8gREUgUklFR08gMDA0IERPTiBNQVJUSU4gMSUwIwYDVQQtExxBQUQ5OTA4MTRCUDcgLyBIRUdUNzYxMDAzNFMyMR4wHAYDVQQFExUgLyBIRUdUNzYxMDAzTURGUk5OMDkxETAPBgNVBAsTCFNlcnZpZG9yMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDlrI9loozd+UcW7YHtqJimQjzX9wHIUcc1KZyBBB8/5fZsgZ/smWS4Sd6HnPs9GSTtnTmM4bEgx28N3ulUshaaBEtZo3tsjwkBV/yVQ3SRyMDkqBA2NEjbcum+e/MdCMHiPI1eSGHEpdESt55a0S6N24PW732Xm3ZbGgOp1tht1wIDAQABox0wGzAMBgNVHRMBAf8EAjAAMAsGA1UdDwQEAwIGwDANBgkqhkiG9w0BAQUFAAOCAQEAuoPXe+BBIrmJn+IGeI+m97OlP3RC4Ct3amjGmZICbvhI9BTBLCL/PzQjjWBwU0MG8uK6e/gcB9f+klPiXhQTeI1YKzFtWrzctpNEJYo0KXMgvDiputKphQ324dP0nzkKUfXlRIzScJJCSgRw9ZifKWN0D9qTdkNkjk83ToPgwnldg5lzU62woXo4AKbcuabAYOVoC7owM5bfNuWJe566UzD6i5PFY15jYMzi1+ICriDItCv3S+JdqyrBrX3RloZhdyXqs2Htxfw4b1OcYboPCu4+9qM3OV02wyGKlGQMhfrXNwYyj8huxS1pHghEROM2Zs0paZUOy+6ajM+Xh0LX2w==\" subTotal=\"0.16E2\" total=\"0.19E2\" metodoDePago=\"EFECTIVO\" LugarExpedicion=\"YUCAT&#xC1;N, M&#xC9;XICO\" folio=\"10\" Moneda=\"MXN\">  <cfdi:Emisor rfc=\"AAD990814BP7\" nombre=\"Empresa de Victor\">    <cfdi:DomicilioFiscal pais=\"M&#xE9;xico\" calle=\"GABRIEL TEPEPA\" municipio=\"Morelos\" noExterior=\"19\" colonia=\"COLORINES\" localidad=\"Cuautla\" codigoPostal=\"64743\"/>    <cfdi:RegimenFiscal Regimen=\"0\"/>  </cfdi:Emisor>  <cfdi:Receptor rfc=\"AAD990814BP7\" nombre=\"Empresa de Victor\">    <cfdi:DomicilioFiscal pais=\"M&#xE9;xico\" calle=\"GABRIEL TEPEPA\" municipio=\"Morelos\" noExterior=\"19\" colonia=\"COLORINES\" localidad=\"Cuautla\" codigoPostal=\"64743\"/>  </cfdi:Receptor></cfdi:Comprobante>")

  end

end