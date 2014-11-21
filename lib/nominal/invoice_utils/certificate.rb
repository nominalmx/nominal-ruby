require 'openssl'

module Nominal
  module InvoiceUtils

    # Certificados .cer en formato X590
    class Certificate < OpenSSL::X509::Certificate

      # el path del certificado
      attr_reader :path
      # el número de certificado
      attr_reader :certificate_number
      # el certificado en Base64
      attr_reader :data
      # la información del certificado en formato pem
      attr_reader :certificate_pem
      # la fecha de inicio de vigencia del certificado
      attr_reader :start_date
      # la fecha final de vigencia del certificado
      attr_reader :end_date
      # el RFC del certificado
      attr_reader :rfc

      # Importar un certificado de sellado
      # @param  file_path [String] El 'path' del certificado o un objeto #IO
      #
      # @return [Invoice::Certificado] Un certificado
      def initialize (file)

        if File.file?(file)
          @path = file
          file = File.read(@path)
        end

        super file

        @certificate_number = '';
        # Unicamente se toma cada segundo dígito, normalmente son strings de tipo:
        # 3230303031303030303030323030303030323933
        self.serial.to_s(16).scan(/.{2}/).each { |v| @certificate_number += v[1]; }
        @data = self.to_s.gsub(/^-.+/, '').gsub(/\n/, '')

        @start_date = self.not_before
        @end_date = self.not_after
        @rfc = parse_rfc

      end

      def generate_pem
        cmd = 'openssl'
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
          stdin.write "x509 -inform DER -outform PEM -in #{@path} -pubkey -out #{@path}.pem"
          stdin.close
        end
        begin
          file = File.open(@path + ".pem", "rb")
          @certificate_pem = file.read
        ensure
          file.close unless file == nil
        end
      end

      # determina si el certificado es de tipo FIEL buscando una serie de caracteres
      # en caso de no encontrarlos regresa 0 (false), en caso de encontrarlos regresa
      # 1 (true)
      def certificate_fiel?
        pem_path = @path + ".pem"
        return !system('openssl x509 -in ' + pem_path + ' -noout -subject -nameopt compat | grep -ci "/OU=" ')
      end

      private
      def parse_rfc
        rfc = self.subject.to_s
        # se busca el identificador y se obtienen los siguientes 13 caracteres
        rfc = rfc[rfc.index('UniqueIdentifier=') + 17, 13]
        # si el caracter 13 no es alphanumerico, se elimina
        if (rfc[12] =~ /\A\p{Alnum}+\z/).nil?
          rfc = rfc[0, 12]
        end
        return rfc
      end
    end

  end

end