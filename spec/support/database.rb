dbconfig = YAML::load_file(File.join(__dir__, 'database.yml'))
ActiveRecord::Base.establish_connection(dbconfig['postgresql'])

ActiveRecord::Schema.define :version => 0 do

  create_table :versioned_products, versioned: true, force: true do |t|
    t.string :name
    t.decimal :price
  end
end
