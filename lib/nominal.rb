# Nominal Ruby bindings
# API spec at https://www.nominal.mx/docs/api
require "json"

require "nokogiri"

#Version
require "nominal/version"

#XML Marshallers
require "nominal/serializers/xml_serializer"

#API Operations
require "nominal/operations/find"

#Invoice XML Attributes
require "nominal/invoice_attributes/properties"
require "nominal/invoice_attributes/concept"
require "nominal/invoice_attributes/issuer"
require "nominal/invoice_attributes/receptor"
require "nominal/invoice_attributes/fiscal_address"
require "nominal/invoice_attributes/issued_address"
require "nominal/invoice_attributes/tax"
require "nominal/invoice_attributes/withholding"
require "nominal/invoice_attributes/transfer"

#Payroll
require "nominal/invoice_attributes/payroll"
require "nominal/invoice_attributes/deductions"
require "nominal/invoice_attributes/perceptions"
require "nominal/invoice_attributes/incapacity"
require "nominal/invoice_attributes/overtime"

#Resources
require "nominal/error"
require "nominal/nominal_object"
require "nominal/resource"
require "nominal/requestor"
require "nominal/invoice"
require "nominal/util"
require "nominal/money_utils"

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