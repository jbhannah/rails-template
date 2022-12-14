# frozen_string_literal: true

# Protect specified model attributes from inclusion in serialized
# representations, without otherwise affecting the behavior of
# ActiveModel::Serialization.serializable_hash.
module AttributeProtector
  extend ActiveSupport::Concern
  include ActiveModel::Serialization

  class_methods do
    attr_reader :protected_attributes

    def protect_attributes(*args)
      (@protected_attributes ||= []).push(*args).flatten!
    end
  end

  def serializable_hash(options = nil)
    options ||= {}

    (options[:except] ||= []).push(*self.class.protected_attributes).uniq!
    %i[methods only].each { |opt| reject_protected_attributes(options[opt]) }

    super
  end

  private

  def reject_protected_attributes(array)
    array&.reject! { |val| self.class.protected_attributes.include?(val) }
  end
end
