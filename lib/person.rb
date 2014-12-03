require 'job'

class Person < ActiveRecord::Base
  extend PeoplesoftModels::Person

  has_many :job, class_name: "Job", primary_key: self.primary_key, foreign_key: self.primary_key
  has_many :effective_job, -> { effective }, class_name: "Job", primary_key: self.primary_key, foreign_key: self.primary_key
end
