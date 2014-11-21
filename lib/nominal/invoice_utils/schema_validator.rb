require 'openssl'
require 'open3'

module Nominal
  module InvoiceUtils

    class SchemaValidator

      # variable estática que carga los archivo xslt del CFDI y TFD
      @@xsd = Nokogiri::XML::Schema(IO.read(File.join(__dir__, 'sat', 'originals', 'cfdv32.xsd')))

      def self.validate_xml xml
        doc = Nokogiri::XML(xml)
        errors = []
        @@xsd.validate(doc).each do |error|
          errors << error.to_s
        end
        errors
      end

    end

  end
end