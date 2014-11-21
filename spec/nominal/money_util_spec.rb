require 'spec_helper'

describe Nominal::MoneyUtils do

  it "round number to specified precision" do

    number = BigDecimal.new("10.00")
    final = number.round(2, BigDecimal::ROUND_HALF_EVEN)

    p number.to_s, final.to_s

    number = Nominal::MoneyUtils.number_to_rounded_precision("10.0015")
    #p number
  end

end