# frozen_string_literal: true

class HashFieldsDecorator
  attr_reader :model_name

  def initialize(field_name, hash)
    @model_name = ActiveModel::Name.new(self.class, nil, field_name.to_s)
    @object = hash.symbolize_keys
  end

  # Delegates to the wrapped object
  def method_missing(method, *args, &block)
    if @object.respond_to? method
      @object.send(method, *args, &block)
    else
      @object[method]
    end
  end

  def has_attribute?(attr)
    @object.key? attr
  end
end
