module IndianaSearch
  module Configuration
    def configuration
      fail(StandardError, "Please set IndianaSearch.configuration = {api_key: 'YOUR_CONSUMER_KEY'}") unless defined?(@@configuration)
      @@configuration
    end

    def configuration=(configuration)
      @@configuration = {
        host:    'http://localhost:3000',
        version: 'api/v1/'
      }.merge(configuration)
    end
  end
end
