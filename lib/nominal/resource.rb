module Nominal
  class Resource < NominalObject

    def self.class_name
      self.name.split('::')[-1]
    end

    def self.url
      if self == Resource
        raise NotImplementedError.new('APIResource is an abstract class.  You should perform actions on its subclasses (Charge, Customer, etc.)')
      end
      "/#{CGI.escape(class_name.downcase)}s"
    end

    def url
=begin
      unless id = self['id']
        raise InvalidRequestError.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}", 'id')
      end
=end
      "#{self.class.url}/#{CGI.escape(id)}"
    end

  end
end