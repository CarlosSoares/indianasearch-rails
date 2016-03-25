class Company < ActiveRecord::Base
  extend IndianaSearch

  add_indiana_index :id
  add_indiana_columns :name
end
