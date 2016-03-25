module IndianaSearch
  module Configuration
    def configuration
      @@configuration || raise(StandartError, "Please configure IndianaSearch. Set IndianaSearch.configuration = {api_key: 'YOUR_API_KEY'}")
    end

    def configuration=(configuration)
      @@configuration = {
        host:    'http://localhost:3000',
        version: '/api/v1/'
      }.merge(configuration)
    end
  end
end
