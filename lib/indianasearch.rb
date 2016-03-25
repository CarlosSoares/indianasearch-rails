require "indianasearch/base"
require "indianasearch/class_methods"
require "indianasearch/configuration"

module IndianaSearch
  extend Configuration

  def self.extended(receiver)
    receiver.class_attribute :indiana_attributes, :indiana_index
    receiver.indiana_attributes = {}
    receiver.indiana_index = :id

    receiver.extend ClassMethods
  end

end
