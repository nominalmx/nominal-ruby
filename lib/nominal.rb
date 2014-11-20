# Nominal Ruby bindings
# API spec at https://www.nominal.mx/docs/api
require "json"

#Version
require "nominal/version"

#API Operations
require "nominal/operations/find"

#Resources
require "nominal/error"
require "nominal/nominal_object"
require "nominal/resource"
require "nominal/requestor"
require "nominal/invoice"
require "nominal/util"

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

  def self.api_key
    @api_key
  end

  def self.api_key=(api_key)
    @api_key = api_key
  end

  def self.private_api_key
    @private_api_key
  end

  def self.private_api_key=(private_api_key)
    @private_api_key = private_api_key
  end

  def self.public_api_key
    @public_api_key
  end

  def self.public_api_key=(public_api_key)
    @public_api_key = public_api_key
  end

end