require 'spec_helper'

describe IndianaSearch do
  before do
    name = Faker::Company.name
    Company.create(name: "#{name} 1")
    Company.create(name: "#{name} 2")
    Company.create(name: "#{name} 3")
  end

  describe 'configuration' do
    it 'should raise error if configuration was not defined' do
      expect{ IndianaSearch.configuration }.to raise_error(StandardError)
    end

    it 'should set the configuration with defaults' do
      IndianaSearch.configuration = { api_token: 'API TOKEN' }
      expect(IndianaSearch.configuration).to eql(api_token: 'API TOKEN', host:'http://localhost:3000', version: 'api/v1/')
    end

    it 'should get the default configuration' do
      IndianaSearch.configuration = {}
      expect(IndianaSearch.configuration).to eql(host:'http://localhost:3000', version: 'api/v1/')
    end

  end

  describe 'ClassMethods' do

    describe '#add_indiana_columns' do
      it 'should allow add new columns' do
        Company.add_indiana_columns(:new_column, :new_column2)
        expect(Company.indiana_attributes).to include('new_column', 'new_column2')
      end

      it 'should allow add new columns' do
        Company.add_indiana_column(:new_column)
        expect(Company.indiana_attributes).to include('new_column')
      end
    end

    describe '#add_indiana_index' do
      it 'should have a default index' do
        expect(Company.indiana_index).to eql(:id)
      end
      it 'should have a default index' do
        Company.add_indiana_index(:name)
        expect(Company.indiana_index).to eql(:name)
      end
    end

    describe '#publish_entry' do
      let(:company) { Company.create(name: 'Gem company') }

      before do
        IndianaSearch.configuration = { api_token: 'token' }
        Company.create(name: 'Gem company 2')
        Company.create(name: 'Gem company 3')
      end

      it 'should call get_indianasearch when object isn\'t an array' do
        expect(Company).to receive(:get_indianasearch)
        allow(RestClient).to receive(:post)
        Company.publish_entry('company', company)
      end

      it 'should not call get_indianasearch when object is an array' do
        expect(Company).not_to receive(:get_indianasearch)
        allow(RestClient).to receive(:post)
        Company.publish_entry('company', [company])
      end

      it 'should call the endpoint with the right info' do
        url = [IndianaSearch.configuration[:host], IndianaSearch.configuration[:version], 'company', 'index'].join('/')

        expect(RestClient).to receive(:post).with(url,
                                                  { data: [company.attributes] }.to_json,
                                                  { Authorization: "Bearer #{IndianaSearch.configuration[:api_token]}",
                                                    content_type: :json, accept: :json })
        Company.publish_entry('company', [company.attributes])
      end

    end

    describe '#search' do
      it 'should call the endpoint with search params' do
        url = [IndianaSearch.configuration[:host], IndianaSearch.configuration[:version],
             'company', 'search', 'name', URI.encode('This is a string to search')].join('/')

        expect(RestClient).to receive(:get).with(url,
                                                  { Authorization: "Bearer #{IndianaSearch.configuration[:api_token]}",
                                                    content_type: :json, accept: :json })
        Company.search('company', 'name', 'This is a string to search')
      end
    end

    describe '#reindex_all' do
      it 'should call publish_entry with data' do
        Company.indiana_attributes = {}
        expect(Company).to receive(:publish_entry)
        Company.reindex_all
      end
    end

    describe '#get_indianasearch' do
      let(:company) { Company.create(name: 'Gem company') }

      it 'should prepare the data' do
        Company.indiana_index = :id
        Company.indiana_attributes = { name: proc { |o| o.send(:name) } }

        expect(Company.send(:get_indianasearch, company)).to eql({id: company.id, name: company.name})
      end
    end
  end

  it 'should this have table' do
    #a = IndianaSearch.included_in.first.reindex_all
    #result = Company.search(Company.table_name, :name, Company.first.name)
  end
end
