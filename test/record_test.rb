require 'test_helper'

class RecordTest < Minitest::Test
  def setup
    @record = PeoplesoftModels::Record.new(recname: "BLAH")
  end

  def test_blank_table_name
    @record.stub(:sqltablename, " ") do
      assert_equal("PS_BLAH", @record.table_name)
    end

    @record.stub(:sqltablename, nil) do
      assert_equal("PS_BLAH", @record.table_name)
    end
  end

  def test_nonblank_table_name
    table = "ASDF"
    @record.stub(:sqltablename, table) do
      assert_equal(table, @record.table_name)
    end
  end

  def test_effective_dated
    @record.stub(:keys, ["blah", "meh", "effdt"]) do
      assert(@record.effective_dated?)
    end
  end

  def test_not_effective_dated
    @record.stub(:keys, ["blah", "meh"]) do
      assert(!@record.effective_dated?)
    end
  end

  def test_not_effective_dated_model
    @record.stub(:keys, ["blah", "meh"]) do
      model = @record.to_model
      assert(model.class != NilClass)
      assert_equal(Class, model.class)
      assert(PeoplesoftModels::Base, model.class.superclass)
    end
  end

  def test_schema_prefix
    schema = "campus_solutions"
    recname = "blah"
    PeoplesoftModels::Base.stub(:schema_name, schema) do
      record = PeoplesoftModels::Record.new(recname: recname)
      assert(record.table_name == "#{schema}.PS_#{recname}")
    end
  end

  def test_uses_schema_prefix
    schema = "some_schema"
    PeoplesoftModels::Base.stub(:schema_name, schema) do
      assert(PeoplesoftModels::Record.table_name.match(%r(^#{schema}\.)))
    end
  end
end
