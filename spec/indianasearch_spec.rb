require 'spec_helper'

describe IndianaSearch do
  before do
    Company.create(name: 'Hi 1')
    Company.create(name: 'Hi 2')
    Company.create(name: 'Hi 3')
    IndianaSearch.configuration = { api_token: 'Nf5EqDZEJ9-QETpuzBsC' }
  end

  it 'should this have table' do
    result = Company.search('clients', :name, Company.first.name)

    byebug
  end
end
