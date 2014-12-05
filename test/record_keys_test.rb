require 'test_helper'

class RecordKeysTest < Minitest::Test
  def setup
    @record = PeoplesoftModels::Record.new(recname: "BLAH")
    @record.fields.build(fieldname: "a", useedit: 1)
    @record.fields.build(fieldname: "b", useedit: 2)
    @record.fields.build(fieldname: "c", useedit: 3)
    @record.fields.build(fieldname: "d", useedit: 4)
    @record.save
  end

  def teardown
    @record.fields.delete_all
    @record.destroy
  end

  def test_key_lookup
    skip_if_using_real_peoplsoft

    keys = @record.keys

    assert(keys.include?("a"))
    assert(keys.include?("c"))
  end
end
