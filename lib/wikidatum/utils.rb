# frozen_string_literal: true

module Wikidatum::Utils
  # Yum!
  def self.ingest_snak(json)
    # the type can be 'novalue' (no value) or 'somevalue' (unknown), so we handle those as somewhat special cases
    case json['value']['type']
    when 'novalue'
      Wikidatum::DataType::Base.marshal_load('novalue', nil)
    when 'somevalue'
      Wikidatum::DataType::Base.marshal_load('somevalue', nil)
    when 'value'
      Wikidatum::DataType::Base.marshal_load(json['property']['data-type'], json['value']['content'])
    end
  end

  def self.symbolized_name_for_data_type(data_type)
    unless Wikidatum::DataType::DATA_TYPES.keys.include?(data_type&.to_sym)
      puts "WARNING: Unsupported data type (#{data_type})"
      return nil
    end

    Object.const_get(Wikidatum::DataType::DATA_TYPES[data_type&.to_sym]).symbolized_name
  end
end
