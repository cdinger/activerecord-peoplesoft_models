require "composite_primary_keys"
require "peoplesoft_models/base"
require "peoplesoft_models/version"
require "peoplesoft_models/record"
require "peoplesoft_models/field"

module PeoplesoftModels
  def self.const_missing(name)
    path = name.to_s.demodulize.underscore

    begin
      klass = Class.new(PeoplesoftModels::Base) do
        @record =  Record.where(recname: path.upcase).first!

        self.table_name     = @record.table_name
        self.primary_keys   = @record.keys
        self.extend(EffectiveScope) if @record.effective_dated?
      end

      const_set(name, klass)
    rescue ActiveRecord::RecordNotFound
      super(name)
    end
  end
end
