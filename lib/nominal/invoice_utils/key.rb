require 'openssl'
require 'open3'

module Nominal
  module InvoiceUtils

    # llave privada, en formato X509 no PKCS7
    #
    # Para convertirlos:
    #     openssl pkcs8 -inform DER -in nombreGiganteDelSAT.key -passin pass:miFIELCreo >> certX509.pem
    class Key < OpenSSL::PKey::RSA

      # el path de la llave
      attr_reader :path
      # el path de la llave pem
      attr_reader :pem_path
      # el path de la llave .pem.enc
      attr_reader :enc_pem_path
      # la contraseña de la llave
      attr_reader :password
      # la información de la llave en formato .pem
      attr_reader :pem
      # la información de la llave en formato .pem.enc
      attr_reader :enc_pem
      attr_reader :data

      # Crea una llave privada
      # @param  file [IO, String] El 'path' de esta llave o los bytes de la misma
      # @param  password=nil [String, nil] El password de esta llave
      #
      # @return [Invoice::Key] La llave privada
      def initialize file, password=nil
        @password = password
        if File.file?(file)
          @path = file
          @pem_path = file + ".pem"
          @enc_pem_path = @pem_path + ".enc"
          generate_pem
        end

        if File.file?(file)
          file = File.read(@pem_path)
        end
        super file, password
        @data = self.to_s.gsub(/^-.+/, '').gsub(/\n/, '')
      end

      # verifica que la llave y un certificado son pareja verificando sus modulus
      def certificate_key_pair? certificate_path
        cer_modulus = ''
        key_modulus = ''
        cmd = 'openssl'
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
          stdin.write "x509 -inform DER -in #{certificate_path} -noout -modulus"
          stdin.close
          cer_modulus = stdout.read
        end

        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
          stdin.write "rsa -in #{@pem_path} -noout -modulus"
          stdin.close
          key_modulus = stdout.read
        end
        return cer_modulus == key_modulus
      end

      # Sella una factura
      #
      # @param xml El XML a sellar
      #
      # @return El sello
      def seal xml
        @cadena = Nominal::InvoiceUtils::OriginalChain.invoice_original_chain_xslt.transform(Nokogiri::XML(xml))
        return Base64::encode64(self.sign(OpenSSL::Digest::SHA1.new, @cadena)).gsub(/\n/, '')
      end

      # Se encripta el pem generado, requerido para cancelar
      def encrypt_pem encrypt_password
        cipher = OpenSSL::Cipher::Cipher.new('des3')
        return to_pem(cipher, encrypt_password)
      end

      # Se genera el pem requerido para sellar
      def generate_pem
        cmd = 'openssl'
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
          stdin.write "pkcs8 -inform DER -in #{@path} -passin \"pass:#{@password}\" -out #{@pem_path}"
          stdin.close
          exit_code = wait_thr.value
          raise "Error en la contraseña de la llave privada" unless exit_code.success?
        end

        begin
          file = File.open(@pem_path, "rb")
          @pem = file.read
        ensure
          file.close unless file == nil
        end
      end

    end

  end
end

