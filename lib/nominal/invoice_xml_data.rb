module Nominal

  class InvoiceXmlData
    include Properties

    has_properties :version,
                   :expedition_date,
                   :seal,
                   :payment_form,
                   :certificate_number,
                   :certificate_data,
                   :subtotal,
                   :total,
                   :payment_method,
                   :voucher_type_text,
                   :expedition_place,
                   :serie,
                   :folio,
                   :payment_terms,
                   :discount,
                   :discount_reason,
                   :exchange_rate,
                   :currency,
                   :payment_account_number,
                   :orig_fiscal_folio,
                   :orig_fiscal_folio_serie,
                   :orig_fiscal_folio_date,
                   :orig_fiscal_folio_amount,
                   :precision,

                   #Nodes
                   :issuer,
                   :receptor,
                   :concepts,
                   :tax,

                   #Complementos
                   :payroll,
                   :donee

    def to_xml

      invoice_attr = generate_attributes

      builder = Nokogiri::XML::Builder.new do |xml|
        xml.Comprobante(invoice_attr) do

          xml.doc.root.namespace = xml.doc.root.add_namespace_definition('cfdi', 'http://www.sat.gob.mx/cfd/3')

          #Check
          self.issuer.to_xml(xml) unless self.issuer.nil?

          #Check
          self.receptor.to_xml(xml) unless self.receptor.nil?

          #Check
          if Util.is_not_empty_array? self.concepts
            xml.Conceptos() {
              self.concepts.each { |concept| concept.to_xml(xml, self.precision) }
            }
          end

          #Check
          self.tax.to_xml(xml, self.precision) unless self.tax.nil?

          #Check
          unless self.payroll.nil?
            xml.Complemento() {
              self.payroll.to_xml(xml, self.precision)
            }
          end

          #Check
          unless self.donee.nil?
            xml.Complemento() {
              self.donee.to_xml(xml)
            }
          end

        end
      end

      builder.to_xml

    end

    private
    def generate_attributes

      self.version ||= 3.2
      self.precision ||= 2

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
      invoice_attr[:subTotal] = MoneyUtils.number_to_rounded_precision(self.subtotal, self.precision)
      invoice_attr[:total] = MoneyUtils.number_to_rounded_precision(self.total, self.precision)
      invoice_attr[:metodoDePago] = self.payment_method
      invoice_attr[:tipoDeComprobante] = self.voucher_type_text.downcase unless self.voucher_type_text.nil?
      invoice_attr[:LugarExpedicion] = self.expedition_place

      invoice_attr[:serie] = self.serie unless self.serie.nil?
      invoice_attr[:folio] = self.folio unless self.folio.nil?
      invoice_attr[:condicionesDePago] = self.payment_terms unless self.payment_terms.nil?
      invoice_attr[:descuento] = MoneyUtils.number_to_rounded_precision(self.discount, self.precision) unless self.discount.nil?
      invoice_attr[:motivoDescuento] = self.discount_reason unless self.discount_reason.nil?
      invoice_attr[:TipoCambio] = self.exchange_rate unless self.exchange_rate.nil?
      invoice_attr[:Moneda] = self.currency unless self.currency.nil?
      invoice_attr[:NumCtaPago] = self.payment_account_number unless self.payment_account_number.nil?
      invoice_attr[:FolioFiscalOrig] = self.orig_fiscal_folio unless self.orig_fiscal_folio.nil?
      invoice_attr[:SerieFolioFiscalOrig] = self.orig_fiscal_folio_serie unless self.orig_fiscal_folio_serie.nil?
      invoice_attr[:FechaFolioFiscalOrig] = self.orig_fiscal_folio_date unless self.orig_fiscal_folio_date.nil?
      invoice_attr[:MontoFolioFiscalOrig] = self.orig_fiscal_folio_amount unless self.orig_fiscal_folio_amount.nil?

      invoice_attr

    end

  end

end