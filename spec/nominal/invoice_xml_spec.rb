require 'spec_helper'

describe Nominal::InvoiceXmlData do

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

end