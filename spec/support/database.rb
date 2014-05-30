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

  create_table :tags, force: true do |t|
    t.string :name
  end

  create_table :tags_versioned_products, force: true, id: false do |t|
    t.references :versioned_product, :tag
  end

  create_table :packages, force: true do |t|
    t.string :dimensions
  end

  create_table :packages_versioned_products, force: true, id: false do |t|
    t.references :versioned_product, :package
    t.integer :versioned_product_version
  end

  create_table :installations, force: true do |t|
    t.references :versioned_product, :office
    t.string :installed_by
  end

  create_table :offices, force: true do |t|
    t.string :address
  end

  create_table :containers, versioned: true, force: true do |t|
    t.references :versioned_product
    t.integer :versioned_product_version
    t.string :name
  end
end
