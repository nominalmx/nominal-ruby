require 'spec_helper'

describe Nominal::Invoice do

  describe Nominal::Attributes::Concept do

    it "can be XML marshalled" do

      concept = Nominal::Attributes::Concept.new(4.0000, 4, 4, 4.0000, 16.0000)

      builder = Nokogiri::XML::Builder.new do |xml|
        xml.Conceptos {
          concept.to_xml(xml)
        }
      end

      xml = builder.to_xml

      expect(xml).to eq("<?xml version=\"1.0\"?>\n<Conceptos>\n  <Concepto cantidad=\"4.0\" unidad=\"4\" descripcion=\"4\" valorUnitario=\"0.4E1\" importe=\"0.16E2\"/>\n</Conceptos>\n")

    end

  end

end