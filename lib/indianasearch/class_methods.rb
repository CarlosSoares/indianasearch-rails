# encoding: utf-8
require 'rest-client'
module IndianaSearch
  module ClassMethods

     def add_indiana_column(*names)
      names.flatten.each do |name|
        self.indiana_attributes[name.to_s] = Proc.new { |o| o.send(name) }
      end
    end
    alias :add_indiana_columns :add_indiana_column

    def add_indiana_index(column)
      self.indiana_index = column
    end

    def publish_entry(resource, obj)
      RestClient.get("#{IndianaSearch.configuration[:host]}#{IndianaSearch.configuration[:version]}/#{resource}/search/")
    end

    def search(resource, column, value)
      url = "#{IndianaSearch.configuration[:host]}#{IndianaSearch.configuration[:version]}/#{resource}/search/#{column}/#{URI.encode(value)}"
      RestClient.get(url, Authorization: "Bearer #{IndianaSearch.configuration[:api_token]}")
    end

    private

    def get_indianasearch(obj)
      attrs = {}
      attrs[self.indiana_index] = obj.try(self.indiana_index)
      self.indiana_attributes.map { |key, o| attrs[key] = o.call(obj) }
      attrs
    end
  end
end
