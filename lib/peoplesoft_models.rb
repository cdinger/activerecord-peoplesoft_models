require "composite_primary_keys"
require "peoplesoft_models/base"
require "peoplesoft_models/version"
require "peoplesoft_models/record"
require "peoplesoft_models/field"

module PeoplesoftModels
  def self.const_missing(name)
    record_name = name.to_s.demodulize.underscore.upcase

    begin
      const_set(name, Record.find(record_name).to_model)
    rescue ActiveRecord::RecordNotFound
      super(name)
    end
  end
end
