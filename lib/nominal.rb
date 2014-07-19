require 'json'
require "nominal/version"

module Nominal
  @api_base = 'https://api.nominal.mx'
  @api_version = '0.0.1'
  def self.api_base
    @api_base
  end
  def self.api_base=(api_base)
    @api_base = api_base
  end
  def self.api_version
    @api_version
  end
  def self.api_version=(api_version)
    @api_version = api_version
  end
end