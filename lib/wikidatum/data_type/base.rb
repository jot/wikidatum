# frozen_string_literal: true

# For more information on the possible types that can be returned by
# datavalues, see the official documentation:
# https://doc.wikimedia.org/Wikibase/master/php/md_docs_topics_json.html#json_datavalues
module Wikidatum::DataType
  class Base
    # Represents the type for this instance.
    #
    # Possible values for the `type` attribute are:
    #
    # - `:no_value`: No value
    # - `:some_value`: Unknown value
    # - `:globe_coordinate`: {DataType::GlobeCoordinate}
    # - `:monolingual_text`: {DataType::MonolingualText}
    # - `:quantity`: {DataType::Quantity}
    # - `:string`: {DataType::WikibaseString}
    # - `:time`: {DataType::Time}
    # - `:wikibase_item`: {DataType::WikibaseItem}
    #
    # @return [Symbol]
    attr_reader :type

    # The value of the "content" attribute in the response.
    #
    # If the `type` is `novalue` or `somevalue`, this returns `nil`.
    #
    # @return [DataType::GlobeCoordinate, DataType::MonolingualText, DataType::Quantity, DataType::WikibaseString, DataType::Time, DataType::WikibaseItem, nil]
    attr_reader :content

    # @param type [Symbol]
    # @param content [DataType::GlobeCoordinate, DataType::MonolingualText, DataType::Quantity, DataType::WikibaseString, DataType::Time, DataType::WikibaseItem, nil] nil if type is no_value or some_value
    # @return [void]
    def initialize(type:, content:)
      @type = type
      @content = content
    end

    # @return [Hash]
    def to_h
      {
        type: @type,
        content: @content&.to_h
      }
    end

    # @!visibility private
    #
    # @param data_type [String] The value of `data-type` for the given Statement or Qualifier's property.
    # @param data_value_json [Hash] The `content` part of value object.
    # @return [Wikidatum::DataType::Base] An instance of Base.
    def self.marshal_load(data_type, data_value_json)
      unless Wikidatum::DataType::DATA_TYPES.keys.include?(data_type.to_sym)
        puts "WARNING: Unsupported data type (#{data_type})"
        return nil
      end

      Object.const_get(Wikidatum::DataType::DATA_TYPES[data_type.to_sym]).marshal_load(data_value_json)
    end
  end
end
