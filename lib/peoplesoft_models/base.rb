# This base class exists to provide a point to alter the database connection
# that a developer is using to connect to PeopleSoft tables.
#
class PeoplesoftModels::Base < ActiveRecord::Base
  self.abstract_class = true
end
