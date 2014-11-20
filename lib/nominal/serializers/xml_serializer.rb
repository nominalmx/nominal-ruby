module Nominal
  module Serializers
    module InvoiceXML
      module ClassMethods

        attr_accessor :concepts

        def to_xml

          invoice_attr = self.generate_attributes

          builder = Nokogiri::XML::Builder.new do |xml|
            xml.Comprobante(invoice_attr) do

              xml.doc.root.namespace = xml.doc.root.add_namespace_definition('cfdi', 'http://www.sat.gob.mx/cfd/3')

              self.invoice_issuer.to_invoice_xml(xml, self.fiscal_regime, self.invoice_fiscal_address, self.invoice_issued_address)
              self.invoice_receptor.to_invoice_xml(xml, invoice_address)

              xml.Conceptos() {
                self.concepts.each { |concept| concept.to_invoice_xml(xml, self.precision) }
              }

              self.tax.to_invoice_xml(xml, self.precision)

              if !self.payroll.nil?
                xml.Complemento() {
                  self.payroll.to_invoice_xml(xml, self.precision)
                }
              end

              unless self.donee.nil?
                xml.Complemento() {
                  self.donee.to_invoice_xml(xml)
                }
              end
            end
          end

          builder.to_xml

        end

        def generate_attributes

          invoice_attr = {}
          invoice_attr["xmlns:cfdi"] = "http://www.sat.gob.mx/cfd/3"
          invoice_attr["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance"
          invoice_attr["xsi:schemaLocation"] = "http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd"
          invoice_attr[:version] = self.version
          invoice_attr[:fecha] = self.expedition_date.strftime('%FT%R:%S') unless self.expedition_date.is_a? String
          invoice_attr[:sello] = self.seal
          invoice_attr[:formaDePago] = self.payment_form
          invoice_attr[:noCertificado] = self.certificate_number
          invoice_attr[:certificado] = self.certificate_data
          invoice_attr[:subTotal] = number_to_rounded_precision(self.subtotal, self.precision)
          invoice_attr[:total] = number_to_rounded_precision(self.total, self.precision)
          invoice_attr[:metodoDePago] = self.payment_method
          invoice_attr[:tipoDeComprobante] = self.voucher_type_text.downcase
          invoice_attr[:LugarExpedicion] = self.expedition_place

          invoice_attr[:serie] = self.serie if !self.serie.nil?
          invoice_attr[:folio] = self.folio if !self.folio.nil?
          invoice_attr[:condicionesDePago] = self.payment_terms if !self.payment_terms.nil?
          invoice_attr[:descuento] = number_to_rounded_precision(self.discount, self.precision) if !self.discount.nil?
          invoice_attr[:motivoDescuento] = self.discount_reason if !self.discount_reason.nil?
          invoice_attr[:TipoCambio] = self.exchange_rate if !self.exchange_rate.nil?
          invoice_attr[:Moneda] = self.currency if !self.currency.nil?
          invoice_attr[:NumCtaPago] = self.payment_account_number if !self.payment_account_number.nil?
          invoice_attr[:FolioFiscalOrig] = self.orig_fiscal_folio if !self.orig_fiscal_folio.nil?
          invoice_attr[:SerieFolioFiscalOrig] = self.orig_fiscal_folio_serie if !self.orig_fiscal_folio_serie.nil?
          invoice_attr[:FechaFolioFiscalOrig] = self.orig_fiscal_folio_date if !self.orig_fiscal_folio_date.nil?
          invoice_attr[:MontoFolioFiscalOrig] = self.orig_fiscal_folio_amount if !self.orig_fiscal_folio_amount.nil?

          invoice_attr

        end

      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end