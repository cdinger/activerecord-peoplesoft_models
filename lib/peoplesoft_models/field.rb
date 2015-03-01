module PeoplesoftModels
  class Field < Base
    self.primary_keys = "recname", "fieldname"

    def self.table_name
      [self.schema_name, "PSRECFIELD"].compact.join(".")
    end
  end
end
