require 'spec_helper'

describe Nominal::InvoiceUtils::Certificate do

  let(:key_path) do
    root = File.expand_path "../../..", __FILE__
    File.join(root, 'fixtures', 'AAD990814BP7.key').to_s
  end

  let(:password) { "12345678a" }

  describe "initialize" do
    context "success" do
      it "loads key" do
        key = Nominal::InvoiceUtils::Key.new key_path, password
        expect(key.password).to eq(password)
      end
    end
    context "failure" do
      let(:password) { "12345678" }
      it "raise exception" do
        expect{
          Nominal::InvoiceUtils::Key.new key_path, password
        }.to raise_error(OpenSSL::PKey::RSAError)
      end
    end
  end

  describe "#certificate_key_pair?" do

    subject! { Nominal::InvoiceUtils::Key.new key_path, password }
    let(:cert_path) do
      root = File.expand_path "../../..", __FILE__
      File.join(root, 'fixtures', 'AAD990814BP7.cer').to_s
    end

    context "success" do
      it "returns true" do
        result = subject.certificate_key_pair? cert_path
        expect(result).to eq(true)
      end
    end

    context "failure" do

      let(:cert_path) do
        root = File.expand_path "../../..", __FILE__
        File.join(root, 'fixtures', 'AAQM610917QJA.cer').to_s
      end

      it "returns false" do
        result = subject.certificate_key_pair? cert_path
        expect(result).to eq(false)
      end
    end

  end

end