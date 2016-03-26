# encoding: utf-8
require 'rest-client'
module IndianaSearch
  # Add some methods to the class that includes
  module ClassMethods
    def add_indiana_column(*names)
      names.flatten.each do |name|
        indiana_attributes[name.to_s] = proc { |o| o.send(name) }
      end
    end
    alias add_indiana_columns add_indiana_column

    def add_indiana_index(column)
      self.indiana_index = column
    end

    def publish_entry(resource, obj)
      data = obj.is_a?(Array) ? obj : get_indianasearch(obj)
      url = [IndianaSearch.configuration[:host], IndianaSearch.configuration[:version], resource, 'index'].join('/')
      RestClient.post(url,
                      { data: data }.to_json,
                      Authorization: "Bearer #{IndianaSearch.configuration[:api_token]}",
                      content_type: :json, accept: :json)
    end

    def search(resource, column, value)
      url = [IndianaSearch.configuration[:host], IndianaSearch.configuration[:version],
             resource, 'search', column, URI.encode(value)].join('/')
      RestClient.get(url, Authorization: "Bearer #{IndianaSearch.configuration[:api_token]}",
                          content_type: :json, accept: :json)
    end

    def reindex_all
      IndianaSearch.included_in.each do |klass|
        count = klass.count
        klass.find_in_batches(batch_size: 100).each_with_index do |batch, index|
          data = []
          batch.each do |obj|
            data.push(klass.send(:get_indianasearch, obj))
          end
          puts "publishing #{index}/#{count / 100}"
          klass.publish_entry(klass.table_name, data)
        end
      end
    end

    private

    def get_indianasearch(obj)
      attrs = {}
      attrs[indiana_index] = obj.try(indiana_index)
      indiana_attributes.map { |key, o| attrs[key] = o.call(obj) }
      attrs
    end
  end
end
