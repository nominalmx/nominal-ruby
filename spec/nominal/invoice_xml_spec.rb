require 'spec_helper'

describe Nominal::Invoice do

  subject(:invoice) do Nominal::Invoice.new()

  end

  it "can be XML marshalled" do

    xml = invoice.to_xml
    p xml.inspect

  end

end