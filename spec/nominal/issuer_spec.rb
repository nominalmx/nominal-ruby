require 'spec_helper'

describe Nominal::Issuer do

  Nominal.public_api_key = "f1490e5ea07a07a67e703ca52293e"
  Nominal.private_api_key = "f98845c8bac48ccad76211b0766fb"
  Nominal.api_base = "http://api.nominal.dev:3000"

  let!(:private_key_password) { "12345678a" }

  let!(:certificate_contents) do
    root = File.expand_path "../..", __FILE__
    path = File.join(root, 'fixtures', 'GOYA780416GM0.cer').to_s
    File.open(path).read
  end

  let!(:private_key_contents) do
    root = File.expand_path "../..", __FILE__
    path = File.join(root, 'fixtures', 'GOYA780416GM0.key').to_s
    File.open(path).read
  end

  let!(:issuer_data) {
    {
        rfc: "GOYA780416GM0",
        regime: "RÉGIMEN GENERAL DE LEY PERSONAS MORALES",
        person_type: "moral"
    }
  }

  describe "#create" do

    it "creates new issuer with files" do

      begin
        response = Nominal::Issuer.create_with_certs(issuer_data, certificate_contents, private_key_contents, private_key_password)
        p response.issuer.inspect
        p response.issuer.id.inspect
      rescue Exception => e
        p "Exception #{e.inspect}"
      end

    end

  end

  describe "#find" do

    it "finds issuer" do

      response = Nominal::Issuer.create_with_certs(issuer_data, certificate_contents, private_key_contents, private_key_password)
      issuer = response.issuer

      retreived = Nominal::Issuer.find(issuer.id).issuer
      expect(issuer.id).to eq(retreived.id)

    end

    it "fails to find issuer" do

      begin
        Nominal::Issuer.find("9ffbcb4d39a0f1b464ce69b4")
      rescue Nominal::NominalApiError => e
        expect(e.message).to eq("Recurso no encontrado")
      end

    end


  end

  describe "#update" do

    it "updates certs and keys" do

      response = Nominal::Issuer.find("4d978db1db048a570c21c398")
      issuer = response.issuer

      response = issuer.update_certs(certificate_contents, private_key_contents, private_key_password)

      p response.inspect

    end

  end

  describe "#self.validate_certs" do

    let!(:private_key_password) { "12345678a" }

    let!(:certificate_path) do
      root = File.expand_path "../..", __FILE__
      path = File.join(root, 'fixtures', 'GOYA780416GM0.cer').to_s
      path
    end

    let!(:private_key_path) do
      root = File.expand_path "../..", __FILE__
      path = File.join(root, 'fixtures', 'GOYA780416GM0.key').to_s
      path
    end

    let(:another_key_path) do
      root = File.expand_path "../..", __FILE__
      path = File.join(root, 'fixtures', 'AAQM610917QJA.key').to_s
      path
    end

    let!(:rfc) { "GOYA780416GM0" }

    let!(:issuer_type) { Nominal::Issuer::MORAL }

    it "allows valid" do

      response = Nominal::Issuer.validate_certs(rfc, issuer_type, certificate_path, private_key_path, private_key_password)
      p response

    end

    it "denies invalid rfc" do

      begin
        rfc = "AAA010101AAA"
        Nominal::Issuer.validate_certs(rfc, issuer_type, certificate_path, private_key_path, private_key_password)
      rescue Nominal::NominalApiError => e
        expect(e.message).to eq("El RFC del certificado no es igual al RFC de la empresa")
      end

    end

    it "denies invalid private_key_password" do

      begin
        private_key_password = "AAA010101AAA"
        Nominal::Issuer.validate_certs(rfc, issuer_type, certificate_path, private_key_path, private_key_password)
      rescue Nominal::NominalApiError => e
        expect(e.message).to eq("La contraseña de la llave privada es inválida")
      end

    end

    it "denies invalid pair" do

      begin
        Nominal::Issuer.validate_certs(rfc, issuer_type, certificate_path, another_key_path, private_key_password)
      rescue Nominal::UnprocessableEntityError => e
        expect(e.message).to eq("El certificado no concuerda con la llave privada")
      end

    end

  end

end