require "composite_primary_keys"
require "peoplesoft_models/version"
require "peoplesoft_models/record"
require "peoplesoft_models/field"

module PeoplesoftModels
  def self.const_missing(name)
    path = name.to_s.demodulize.underscore

    begin
      mixin = Module.new do
        @record =  Record.where(recname: path.upcase).first!

        def self.extended(base)
          base.table_name     = @record.table_name
          base.primary_keys   = @record.keys
          base.extend(EffectiveScope) if @record.effective_dated?
        end
      end

      mixin
    rescue ActiveRecord::RecordNotFound
      super(name)
    end
  end
end
