require 'spec_helper'

describe Nominal::Invoice do

  Nominal.public_api_key = "f1490e5ea07a07a67e703ca52293e"
  Nominal.private_api_key = "f98845c8bac48ccad76211b0766fb"

  Nominal.api_base = "http://private-6edbb-nominal.apiary-mock.com"

  describe "#find" do
    it "returns a specific invoice" do
      invoice = Nominal::Invoice.find("e5a4ca14f37c1eaf8147b6b9")
      expect(invoice.id).to eq("e5a4ca14f37c1eaf8147b6b9")
     end
  end

end