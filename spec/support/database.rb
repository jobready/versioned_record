env = ENV['VERSIONED_RECORD_ENV'] || 'development'
dbconfig = YAML::load_file(File.join(__dir__, 'database.yml'))
ActiveRecord::Base.establish_connection(dbconfig[env]['postgresql'])

ActiveRecord::Schema.define :version => 0 do

  create_table :companies, force: true do |t|
    t.string :name
  end

  create_table :versioned_products, versioned: true, force: true do |t|
    t.references :company
    t.string :name
    t.decimal :price
  end

  create_table :comments, force: true do |t|
    t.references :versioned_product
    t.string :content
  end

  create_table :sales, force: true do |t|
    t.references :versioned_product
    t.integer :versioned_product_version
    t.string :purchaser
  end
end
