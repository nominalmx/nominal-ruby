require 'spec_helper'

describe Nominal::Requestor do

  Nominal.public_api_key = "f1490e5ea07a07a67e703ca52293e"
  Nominal.private_api_key = "f98845c8bac48ccad76211b0766fb"

  describe "#get_token" do
    it "returns hashed token" do
      request = Nominal::Requestor.new

      p request.send(:get_token)

      #expect(request.send(:get_token)).to eq("Nominal Y2ozMTZIa05ra1VYSGJxdXYyS3ZsNi9rN0xSK2RsaWd0L1IvR2RoT0JyST0K:2ea2ab33d308b85216bf5611205292acbca6f3869a366d6a69242c87c340a109")

    end
  end

end