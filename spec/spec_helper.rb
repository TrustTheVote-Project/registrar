# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

Spec::Runner.configure do |configuration|

  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  configuration.use_transactional_fixtures = true
  configuration.use_instantiated_fixtures  = false

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  configuration.global_fixtures = :all
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # configuration.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # configuration.mock_with :mocha
  # configuration.mock_with :flexmock
  # configuration.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Example::Configuration and Spec::Runner
end

include AuthenticatedTestHelper

# This is here to allow spec helpers to work with spec_server
spec_helpers_dir = File.dirname(__FILE__) + "/spec_helpers"
$LOAD_PATH.unshift spec_helpers_dir
Dir["#{spec_helpers_dir}/**/*.rb"].each do |file|
  require_dependency file
end

# This is here to allow you to integrate views on all of your controller specs
Spec::Runner.configuration.before(:all, :behaviour_type => :controller) do
  @integrate_views = true
end

# This is here to allow you to mock flash on all of your controller specs
Spec::Runner.configuration.before(:all, :behaviour_type => :controller) do
  #set_mock_flash
end

def valid_registration_attributes
  {
      :first_name => 'John',
      :address => '1 Main Street',
      :city => 'Smallville',
      :zip => '12345',
      :state => 'JA',
      :date_of_birth => Date.parse('1970-01-01'),
      :id_number => '123abc'
  }
end