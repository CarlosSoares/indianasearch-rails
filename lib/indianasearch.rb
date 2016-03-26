require 'indianasearch/class_methods'
require 'indianasearch/configuration'

module IndianaSearch
  require 'indianasearch/railtie' if defined?(Rails)
  extend Configuration

  class << self
    attr_reader :included_in

    def extended(receiver)
      receiver.class_attribute :indiana_attributes, :indiana_index
      receiver.indiana_attributes = {}
      receiver.indiana_index = :id

      receiver.extend ClassMethods

      @included_in ||= []
      @included_in << receiver
      @included_in.uniq!
    end
  end
end
