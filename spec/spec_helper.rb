require 'coveralls'
Coveralls.wear!

#require 'active_record'
require 'versioned_record'
require 'database_cleaner'

require 'byebug'

Dir[("./spec/support/**/*.rb")].each {|f| require f}

ActiveRecord::Base.logger = Logger.new(STDOUT)

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.mock_with :rspec
  config.filter_run :focus
  config.order = 'random'
  config.before :each do
    DatabaseCleaner.start
  end
  config.after :each do
    DatabaseCleaner.clean
  end
end
