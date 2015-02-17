require_relative "effective_scope"

module PeoplesoftModels
  class Record < Base
    self.table_name = "psrecdefn"
    self.primary_key = "recname"

    has_many :fields, class_name: "Field",
                      primary_key: self.primary_key,
                      foreign_key: self.primary_key

    # A record's table name "PS_" + the record name unless it's specified in
    # the `sqltablename` field.
    # http://www.go-faster.co.uk/peopletools/psrecdefn.htm
    #
    def table_name
      @table_name ||= begin
        schema = self.class.schema_name
        table = self.sqltablename.blank? ? "PS_#{self.recname}" : self.sqltablename
        [schema, table].compact.join(".")
      end
    end

    # The useedit field holds many values that you can get from the stored
    # integer by applying bit masks. `useedit & 1` determines whether or not a
    # field is part of the primary key. This operation would be marginally
    # faster on the database, but doing it in Ruby let's us avoid handling
    # different syntaxes for the bitwise AND.
    # http://www.go-faster.co.uk/peopletools/useedit.htm
    #
    def keys
      @keys ||= fields.order(:fieldnum).select do |field|
        field.useedit & 1 == 1
      end.map do |field|
        field.fieldname.downcase
      end
    end

    def effective_dated?
      @effective_dated ||= self.keys.include?("effdt")
    end

    def to_model
      return @model if defined? @model
      @model = Class.new(Base)
      @model.table_name = self.table_name
      @model.primary_keys = self.keys
      @model.extend(EffectiveScope) if self.effective_dated?
      @model
    end
  end
end
