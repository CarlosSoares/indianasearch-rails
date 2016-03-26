namespace :indianasearch do
  desc 'Reindex all models'
  task reindex: :environment do
    Rails.application.eager_load!
    puts 'reindexing all models'
    puts IndianaSearch.included_in
    IndianaSearch.included_in.each(&:reindex_all)
  end

  desc 'Clear all indexes'
  task clear_indexes: :environment do
    puts 'clearing all indexes'
    IndianaSearch.included_in.each(&:clean_all_index)
  end
end
