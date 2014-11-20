require 'spec_helper'

describe Nominal do

  it "version must be defined" do
    expect(Nominal::VERSION).to be_truthy
  end

end