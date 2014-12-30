require "bundler"
Bundler.setup
require 'activerecord-peoplesoft_models'
require 'minitest/autorun'

if ENV['DATABASE'].blank?
  ActiveRecord::Base.establish_connection(adapter:"sqlite3", database: ":memory:")
  require 'fake_peoplesoft'
  FakePeoplesoft.create!
else
  ActiveRecord::Base.configurations = YAML::load_file(File.join(File.dirname(__FILE__), 'config', 'database.yml'))
  ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[ENV['DATABASE']])
end

class Minitest::Test
  def skip_if_using_real_peoplsoft
    unless ENV['DATABASE'].blank?
      skip "Not running this destructive test on a real PeopleSoft instance"
    end
  end
end
