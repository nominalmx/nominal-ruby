module Nominal

  class Invoice < Resource
    include Nominal::Operations::Find

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
=begin
      unless id = self['id']
        raise InvalidRequestError.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}", 'id')
      end
=end
      "#{self.class.url}/#{CGI.escape(id)}"
    end

    def stamp_xml(xml)
      self.xml = xml
    end

  end

end