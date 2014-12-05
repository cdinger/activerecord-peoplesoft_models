require 'rubygems'
require "bundler"
Bundler.setup(:default, :development)
$:.unshift(File.expand_path('../../lib', __FILE__))
require 'activerecord-peoplesoft_models'
require 'minitest/autorun'

DATABASE = ENV['DATABASE'] || 'sqlite'

ActiveRecord::Base.configurations = YAML::load_file(File.join(File.dirname(__FILE__), 'config', 'database.yml'))
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[DATABASE])

if DATABASE == 'sqlite'
  require 'fake_peoplesoft'
  FakePeoplesoft.create!
end

class Minitest::Test
  def skip_if_using_real_peoplsoft
    unless DATABASE == 'sqlite'
      skip "Not running this destructive test on a real PeopleSoft instance"
    end
  end
end
