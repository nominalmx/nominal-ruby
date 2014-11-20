require 'spec_helper'

describe Nominal do

  it "version must be defined" do

    request = Nominal::Requestor.new

    expect(Nominal::VERSION).to be_truthy
  end

end