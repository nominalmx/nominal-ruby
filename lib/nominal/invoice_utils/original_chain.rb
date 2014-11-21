require 'openssl'
require 'open3'

module Nominal
  module InvoiceUtils

    class OriginalChain

      # variable estática que carga los archivo xslt del CFDI y TFD
      @@invoice_original_chain_xslt = Nokogiri::XSLT(File.open(File.join(__dir__, 'sat','cadenaoriginal_3_2.xslt')))
      @@tfd_original_chain_xslt = Nokogiri::XSLT(File.read(File.join(__dir__, 'sat','cadenaoriginal_TFD_1_0.xslt')))

      # cadena original del CFDI
      attr_reader :invoice_original_chain
      # cadena original del complemento TFD
      attr_reader :tfd_original_chain

      # Inicializa las cadenas originales disponibles
      # @param  xml [String] El XML del CFDI
      def initialize (xml)
        nok_xml = Nokogiri::XML(xml)
        @invoice_original_chain = @@invoice_original_chain_xslt.transform(nok_xml).to_xml(save_with: Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip

        tfd = nok_xml.at_xpath('//tfd:TimbreFiscalDigital', {'tfd' => 'http://www.sat.gob.mx/TimbreFiscalDigital'})
        if !tfd.nil? and !tfd.blank?
          tfd_nok_xml = Nokogiri::XML(tfd.to_xml)
          @tfd_original_chain = @@tfd_original_chain_xslt.transform(tfd_nok_xml).to_xml(save_with: Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip
        end
      end

      # getters
      def self.invoice_original_chain_xslt
        @@invoice_original_chain_xslt
      end
      def self.tfd_original_chain_xslt
        @@tfd_original_chain_xslt
      end

    end

  end
end