# TODO: explain why this is here (for apps using a different ps connection)
class PeoplesoftModels::Base < ActiveRecord::Base
  self.abstract_class = true
end
