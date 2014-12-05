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
end
