require 'test_helper'

class FieldText < Minitest::Test
  def test_uses_schema_prefix
    schema = "some_schema"
    PeoplesoftModels::Base.stub(:schema_name, schema) do
      assert(PeoplesoftModels::Field.table_name.match(%r(^#{schema}\.)))
    end
  end
end
