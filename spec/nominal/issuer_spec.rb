require 'spec_helper'

describe Nominal::Issuer do

  Nominal.public_api_key = "f1490e5ea07a07a67e703ca52293e"
  Nominal.private_api_key = "f98845c8bac48ccad76211b0766fb"
  Nominal.api_base = "http://api.nominal.dev:3000"

  describe "#create" do

    it "creates new issuer" do

      attr = {
              rfc: "AAD990814BP7",
              regime: "RÉGIMEN GENERAL DE LEY PERSONAS MORALES"
      }

      status = Nominal::Issuer.create(attr)
      p status.inspect

    end

  end

  describe "#self.validate_certs" do

    let!(:private_key_password) { "12345678a" }

    let!(:certificate_path) do
      root = File.expand_path "../..", __FILE__
      path = File.join(root, 'fixtures', 'AAD990814BP7.cer').to_s
      path
    end

    let!(:private_key_path) do
      root = File.expand_path "../..", __FILE__
      path = File.join(root, 'fixtures', 'AAD990814BP7.key').to_s
      path
    end

    let(:another_key_path) do
      root = File.expand_path "../..", __FILE__
      path = File.join(root, 'fixtures', 'AAQM610917QJA.key').to_s
      path
    end

    let!(:rfc) { "AAD990814BP7" }

    let!(:issuer_type) { Nominal::Issuer::MORAL }

    it "allows valid" do

      response = Nominal::Issuer.validate_certs(rfc, issuer_type, certificate_path, private_key_path, private_key_password)
      p response

    end

    it "denies invalid rfc" do

      begin
        rfc = "AAA010101AAA"
        Nominal::Issuer.validate_certs(rfc, issuer_type, certificate_path, private_key_path, private_key_password)
      rescue Nominal::UnprocessableEntityError => e
        expect(e.errors["certificate"].first).to eq("El RFC del certificado no es igual al RFC de la empresa")
      end

    end

    it "denies invalid private_key_password" do

      begin
        private_key_password = "AAA010101AAA"
        Nominal::Issuer.validate_certs(rfc, issuer_type, certificate_path, private_key_path, private_key_password)
      rescue Nominal::UnprocessableEntityError => e
        expect(e.errors["private_key_password"].first).to eq("La contraseña de la llave privada es inválida")
      end

    end

    it "denies invalid pair" do

      begin
        Nominal::Issuer.validate_certs(rfc, issuer_type, certificate_path, another_key_path, private_key_password)
      rescue Nominal::UnprocessableEntityError => e
        expect(e.errors["private_key"].first).to eq("El certificado no concuerda con la llave privada")
      end

    end

  end

end