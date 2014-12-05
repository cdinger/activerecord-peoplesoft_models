require 'test_helper'

class EffectiveScopeTest < Minitest::Test
  def test_no_effective_scope_on_non_effective_model
    assert(!PeoplesoftModels::Person.methods.include?(:effective))
  end

  def test_effective_scope_on_effdt_model
    skip_if_using_real_peoplsoft

    model = PeoplesoftModels::AcadProgTbl
    effdt = Date.today
    attributes = {institution: 'ASDF', acad_prog: 'BLAH'}

    assert_equal(0, model.count)

    model.create(attributes.merge({effdt: effdt - 1.days}))
    model.create(attributes.merge({effdt: effdt}))
    model.create(attributes.merge({effdt: effdt + 1.day}))

    assert_equal(1, model.effective.count)

    effective_row = model.effective.first

    assert_equal(effdt, effective_row.effdt)
  end

  def test_effective_scope_on_effseq_model
    skip_if_using_real_peoplsoft

    model = PeoplesoftModels::AcadProg
    effdt = Date.today
    attributes = {emplid: '123', acad_career: 'A', stdnt_car_nbr: 1, effseq: 0}

    assert_equal(0, model.count)

    model.create(attributes.merge({effdt: effdt - 3.days}))
    model.create(attributes.merge({effdt: effdt - 3.days, effseq: 1}))
    model.create(attributes.merge({effdt: effdt - 3.days, effseq: 2}))
    model.create(attributes.merge({effdt: effdt}))
    model.create(attributes.merge({effdt: effdt, effseq: 1}))
    model.create(attributes.merge({effdt: effdt + 1.day}))

    assert_equal(1, model.effective.count)

    effective_row = model.effective.first

    assert_equal(effdt, effective_row.effdt)
    assert_equal(1, effective_row.effseq)
  end
end
