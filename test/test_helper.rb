require 'rubygems'
require "bundler"
Bundler.setup(:default, :development)
$:.unshift(File.expand_path('../../lib', __FILE__))
require 'activerecord-peoplesoft_models'
require 'minitest/autorun'

ActiveRecord::Base.configurations = YAML::load_file(File.join(File.dirname(__FILE__), 'config', 'database.yml'))
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
ActiveRecord::Base.logger = Logger.new(STDOUT)
