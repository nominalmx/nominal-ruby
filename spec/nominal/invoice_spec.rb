require 'spec_helper'

describe Nominal::Invoice do

  Nominal.public_api_key = "f1490e5ea07a07a67e703ca52293e"
  Nominal.private_api_key = "f98845c8bac48ccad76211b0766fb"

  describe "#find" do

    Nominal.api_base = "http://private-6edbb-nominal.apiary-mock.com"

    it "returns a specific invoice" do
      invoice = Nominal::Invoice.find("e5a4ca14f37c1eaf8147b6b9")
      expect(invoice.id).to eq("e5a4ca14f37c1eaf8147b6b9")
     end
  end

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

  let!(:invoice_data) do

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


  describe "#stamp" do

    Nominal.api_base = "http://api.nominal.dev:3000"

    it "create invoice stamping it" do
      invoice = Nominal::Invoice.stamp_xml(invoice_data, cert, key)
      p invoice.inspect
    end

  end

end