module Nominal

  class Issuer < Resource
    include Nominal::Operations::Find
    include Nominal::Operations::Update

    MORAL = 0
    PHYSICAL = 1

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
      "#{self.class.url}/#{CGI.escape(id)}"
    end

    def self.validate_certs(rfc, issuer_type, certificate_path, private_key_path, private_key_password)

      certificate = File.read(certificate_path)
      private_key = File.read(private_key_path)

      cert_filename = File.basename(certificate_path)
      key_filename = File.basename(private_key_path)

      validate_params = {
          rfc: rfc,
          person_type: issuer_type,
          certificate: { file_data: Base64.encode64(certificate), filename: cert_filename, content_type: "application/octet-stream" },
          private_key: { file_data: Base64.encode64(private_key), filename: key_filename, content_type: "application/octet-stream" },
          private_key_password: private_key_password
      }

      url = [self.url, 'validate_certs'].join('/')
      response = Requestor.new.request(:post, url, nil, validate_params)
      Util.convert_to_nominal_object(response, self.class_name)

    end

    def self.update_certs(id, rfc, certificate_contents, private_key_contents, private_key_password)
      issuer = Nominal::Issuer.new(id)
      issuer.rfc = rfc
      issuer.update_certs(certificate_contents, private_key_contents, private_key_password)
    end

    def update_certs(certificate_contents, private_key_contents, private_key_password)

      rfc = self.rfc

      body = {
          certificate: { file_data: Base64.encode64(certificate_contents), filename: "#{rfc}.cer" , content_type: "application/octet-stream" },
          private_key: { file_data: Base64.encode64(private_key_contents), filename: "#{rfc}.key", content_type: "application/octet-stream" },
          private_key_password: private_key_password
      }

      self.update(body)

    end

    def self.create_with_certs(body, certificate_contents, private_key_contents, private_key_password)

      rfc = body['rfc']

      body = body.merge(
          certificate: { file_data: Base64.encode64(certificate_contents), filename: "#{rfc}.cer" , content_type: "application/octet-stream" },
          private_key: { file_data: Base64.encode64(private_key_contents), filename: "#{rfc}.key", content_type: "application/octet-stream" },
          private_key_password: private_key_password
      )

      url = self.url
      response = Requestor.new.request(:post, url, nil, body)
      Util.convert_to_nominal_object(response, self.class_name)

    end

  end

end