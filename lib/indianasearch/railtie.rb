require 'rails'

module IndianaSearch
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/indianasearch_tasks.rake'
    end
  end
end
