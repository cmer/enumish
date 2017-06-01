# frozen_string_literal: true

require "bundler/setup"
require "enumish"
require "temping"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"
  config.filter_run_when_matching :focus
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
