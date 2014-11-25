require 'spec_helper'

describe Nominal::Issuer do

  Nominal.public_api_key = "f1490e5ea07a07a67e703ca52293e"
  Nominal.private_api_key = "f98845c8bac48ccad76211b0766fb"

  describe "#create" do

    Nominal.api_base = "http://api.nominal.dev:3000"

    it "create" do

      data = {
              rfc: "AAD990814BP7",
              regime: "RÉGIMEN GENERAL DE LEY PERSONAS MORALES"
      }

      status = Nominal::Issuer.create(data)
      p status.inspect

    end

  end

end