require_relative "effective_scope"

module PeoplesoftModels
  class Record < Base
    self.table_name = "psrecdefn"
    self.primary_key = "recname"

    has_many :fields, class_name: "Field",
                      primary_key: self.primary_key,
                      foreign_key: self.primary_key

    # http://www.go-faster.co.uk/peopletools/psrecdefn.htm
    #
    def table_name
      @table_name ||= self.sqltablename.blank? ? "PS_#{self.recname}" : record_row.sqltablename
      @table_name
    end

    # http://www.go-faster.co.uk/peopletools/useedit.htm
    #
    def keys
      key_fields = fields.where("bitand(useedit, 1) = 1").order(:fieldnum)
      key_fields.map { |row| row.fieldname.downcase }
    end

    def effective_dated?
      self.keys.include?("effdt")
    end

    def to_model
      model = Class.new(ActiveRecord::Base)

      model.table_name = self.table_name
      model.primary_keys = self.keys
      model.extend(EffectiveScope) if self.effective_dated?

      model
    end
  end
end
