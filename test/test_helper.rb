require 'rubygems'
require "bundler"
Bundler.setup(:default, :development)
$:.unshift(File.expand_path('../../lib', __FILE__))
require 'activerecord-peoplesoft_models'
require 'minitest/autorun'

DATABASE = ENV['DATABASE'] || 'sqlite'

if DATABASE == 'sqlite'
  ActiveRecord::Base.establish_connection(adapter:"sqlite3", database: ":memory:")

  require 'fake_peoplesoft'
  FakePeoplesoft.create!
else
  ActiveRecord::Base.configurations = YAML::load_file(File.join(File.dirname(__FILE__), 'config', 'database.yml'))
  ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[DATABASE])
end

class Minitest::Test
  def skip_if_using_real_peoplsoft
    unless DATABASE == 'sqlite'
      skip "Not running this destructive test on a real PeopleSoft instance"
    end
  end
end
