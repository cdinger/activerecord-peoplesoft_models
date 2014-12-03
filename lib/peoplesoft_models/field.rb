module PeoplesoftModels
  class Field < ActiveRecord::Base
    self.table_name = "psrecfield"
    self.primary_keys = "recname", "fieldname"
  end
end
