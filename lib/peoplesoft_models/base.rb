# This base class exists to provide a point to alter the database connection
# that a developer is using to connect to PeopleSoft tables. All generated
# models inherit from this class instead of ActiveRecord::Base.
#
module PeoplesoftModels
  class Base < ActiveRecord::Base
    self.abstract_class = true
  end
end
