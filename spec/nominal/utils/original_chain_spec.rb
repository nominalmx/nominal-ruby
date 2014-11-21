require 'spec_helper'

describe Nominal::InvoiceUtils::OriginalChain do

  subject! do
    root = File.expand_path "../../..", __FILE__
    xml = File.read(File.join(root, 'fixtures', 'pre_sealed_cfdi.xml').to_s)
    Nominal::InvoiceUtils::OriginalChain.new xml
  end

  describe "#invoice_original_chain_xslt" do
    it "generates original chain" do
      expect(subject.invoice_original_chain.to_s).to eq("||3.2|2014-09-18T17:39:08|ingreso|PAGO EN UNA SOLA EXHIBICIÓN|1.00|MXN|1.16|EFECTIVO|AGUASCALIENTES, MÉXICO|AAA010101AAA|EMPRESA2|ASDFASD|ASDF|SADF|AGUASCALIENTES|MÉXICO|12341|RÉGIMEN GENERAL DE LEY PERSONAS MORALES|XAXX010101000|PÚBLICO EN GENERAL|MÉXICO|1.0|1|1|1.00|1.00|IVA|16.0|0.16|0.16||")
    end
  end

end