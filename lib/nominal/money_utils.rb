module Nominal
    module MoneyUtils

      require 'bigdecimal'

      def self.number_to_rounded_precision(value, default_precision = nil)
        precision = money_precision(value, default_precision)
        number = round_money(value, precision)
        number
      end

      private
      def self.money_precision(value, default_precision = nil)
        value_precision = (default_precision.nil? || !(default_precision.is_a? Integer)) ? precision(value) : default_precision
        precision = value_precision <= 1 ? 2 : value_precision > 6 ? 6 : value_precision
        precision
      end

      # returns an amount rounded (BANKERS ROUNDING) with SAT precision
      def self.round_money(value, precision)
        value = value.nil? ? '0' : value
        precision = precision.nil? ? 2 : precision
        number = BigDecimal.new(value, precision)
        return number.round(precision, BigDecimal::ROUND_HALF_EVEN)
      end

      # returns the number of decimals in a number
      def self.precision(number)
        s = number.to_s
        return (s[/\.(\d+)/,1] || "").length
      end

    end
end