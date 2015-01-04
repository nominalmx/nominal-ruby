module Nominal

  class Invoice < Resource
    include Nominal::Operations::Find
    include Nominal::Operations::CustomAction

    def self.class_name
      self.name.split('::')[-1]
    end

    def self.url
      if self == Resource
        raise NotImplementedError.new('APIResource is an abstract class.')
      end
      "/#{CGI.escape(class_name.downcase)}s"
    end

    def url
      unless id = self.id
        raise InvalidRequestError.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}", 'id')
      end
      "#{self.class.url}/#{CGI.escape(id)}"
    end

    def self.stamp_xml(data, cert, key)

      data.certificate_data = cert.data
      data.certificate_number = cert.certificate_number
      pre_sealed_xml = data.to_xml
      data.seal = key.seal(pre_sealed_xml)
      xml = data.to_xml.gsub(/\n/, '')

      errors = Nominal::InvoiceUtils::SchemaValidator.validate_xml xml

      raise "Error al construir factura: #{errors.inspect}" unless errors.empty?

      body = {xml: Base64.encode64(xml), via_ux: false}
      #body = { xml: Base64.encode64(xml) }

      url = [self.url, 'stamp_xml'].join('/')
      response = Requestor.new.request(:post, url, nil, body)
      Util.convert_to_nominal_object(response, self.class_name)

    end

    def cancel(certificate, key, pdf = nil)

      certificate_pem = certificate.to_pem
      encrypt_pem = key.encrypt_pem(finkok_password)

      params = {certificate: certificate_pem, key: encrypt_pem}
      custom_action(:post, 'cancel', params, pdf)
    end

    def send_to_mail(to, subject=nil, issuer_id=nil)
      body = {to: to, subject: subject, issuer_id: issuer_id}
      custom_action(:post, 'mail', nil, body)
    end

  end

end