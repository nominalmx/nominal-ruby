require 'spec_helper'

describe Nominal::Invoice do

  Nominal.public_api_key = "f1490e5ea07a07a67e703ca52293e"
  Nominal.private_api_key = "f98845c8bac48ccad76211b0766fb"
  Nominal.api_base = "http://api.nominal.dev:3000"

  describe "#find" do

    Nominal.api_base = "http://private-6edbb-nominal.apiary-mock.com"

    it "returns a specific invoice" do
      invoice = Nominal::Invoice.find("e5a4ca14f37c1eaf8147b6b9")
      expect(invoice.id).to eq("e5a4ca14f37c1eaf8147b6b9")
     end
  end

  let!(:key) do
    root = File.expand_path "../..", __FILE__
    key_path = File.join(root, 'fixtures', 'GOYA780416GM0.key').to_s
    Nominal::InvoiceUtils::Key.new key_path, "12345678a"
  end

  let!(:cert) do
    root = File.expand_path "../..", __FILE__
    #
    path = File.join(root, 'fixtures', 'GOYA780416GM0.cer').to_s
    Nominal::InvoiceUtils::Certificate.new path
  end

  let!(:invoice_data) do

    fiscal_address = Nominal::InvoiceAttributes::FiscalAddress.new({
                                                                       street: "GABRIEL TEPEPA",
                                                                       exterior_number: "19",
                                                                       neighborhood: "COLORINES",
                                                                       locality: "Cuautla",
                                                                       municipality: "Cuautla",
                                                                       state: "Morelos",
                                                                       country: "México",
                                                                       postal_code: "64743"
                                                                   })

    issuer = Nominal::InvoiceAttributes::Issuer.new({
                                                        rfc: "GOYA780416GM0",
                                                        name: "MACRO CLIENT EMPRESA 2",
                                                        fiscal_regime: "RÉGIMEN GENERAL DE LEY PERSONAS MORALES",
                                                        fiscal_address: fiscal_address
                                                    })

    receptor_address = Nominal::InvoiceAttributes::Address.new({
                                                                       street: "13",
                                                                       exterior_number: "102",
                                                                       neighborhood: "Centro",
                                                                       locality: "Merida",
                                                                       municipality: "Merida",
                                                                       state: "Yucatan",
                                                                       country: "México",
                                                                       postal_code: "97210"
                                                                   })

    receptor = Nominal::InvoiceAttributes::Receptor.new({
                                                            rfc: "CGA030903UC3",
                                                            name: "Javier Olan",
                                                            receptor_address: receptor_address
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
                                                          unit_value: 26.00,
                                                          amount: 4,
                                                      })

    invoice_data = Nominal::InvoiceXmlData.new({
                                                   serie: "C",
                                                   folio: 2,
                                                   expedition_date: Date.today,
                                                   subtotal: 43.000000,
                                                   total: 47.5600000,
                                                   payment_form: "PAGO EN UNA SOLA EXHIBICIÓN",
                                                   payment_method: "EFECTIVO",
                                                   currency: "MXN",
                                                   expedition_place: "YUCATÁN, MÉXICO",
                                                   issuer: issuer,
                                                   receptor: receptor,
                                                   voucher_type_text: Nominal::InvoiceXmlData.voucher_expenditure,
                                                   concepts: [concept],
                                                   tax: tax
                                               })

    invoice_data

  end


  describe "#stamp" do

    Nominal.api_base = "http://api.nominal.dev:3000"

    it "create invoice stamping it" do
      status = Nominal::Invoice.stamp_xml(invoice_data, cert, key)
      p status.inspect
    end

  end

  describe "#cancel" do

    Nominal.api_base = "http://api.nominal.dev:3000"

    it "cancels a valid invoice" do

      response = Nominal::Invoice.find("0ff77103638e8ae187d9069c")
      invoice = response.invoice

      response = invoice.cancel(pdf: true)

      p response.inspect
      #expect(invoice.status).to eq("OK")
    end

  end

  describe "#send_to_mail" do

    Nominal.api_base = "http://api.nominal.dev:3000"

    let(:email){ "john@nominal.mx" }

    it "sends to specified mail" do

      invoice =   Nominal::Invoice.find("5ea969e3debc91a9c6607f02")
      issuer_id = "71976758dae2410bb9758401"

      response = invoice.send_to_mail(email, nil, issuer_id)
      p response.inspect

    end

  end

end