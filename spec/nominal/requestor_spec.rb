require 'spec_helper'

require 'nominal/requestor'

describe Nominal::Requestor do

  Nominal.public_api_key = "Y2ozMTZIa05ra1VYSGJxdXYyS3ZsNi9rN0xSK2RsaWd0L1IvR2RoT0JyST0K"
  Nominal.private_api_key = "Y2ozMTZIa05ra1VYSGJxdXYyS3ZsNi9rN0xSK2RsaWd0L1IvR2RoT0JyST0K"

  describe "#get_token" do
    it "returns hashed token" do
      request = Nominal::Requestor.new

      p request

    end
  end

end