# Peoplesoft Models for ActiveRecord

This Rubygem provides an easy way to build ActiveRecord models for interacting
with a PeopleSoft database. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-peoplesoft_models', '~> 0.0.1'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-peoplesoft_models

## Usage

PeoplesoftModels works by dynamically constructing modules that you can mix
ActiveRecord classes in your project. Providing modules allows you to name your
classes in a meaningful way for your problem domain. If your customers say
"minor" instead of "academic sub-plan", that's OK. Use domain language!

```ruby
class Minor < ActiveRecord::Base
  extend PeoplesoftModels::AcadSubplnTbl
end
```

The PeoplesoftModles::AcadSubPlanTbl module will:

- set the table name
- set the primary keys
- include an `effective` scope (if the table is effective dated)

```ruby
Minor.table_name
=> "PS_ACAD_SUBPLN_TBL"

Minor.primary_keys
=> ["institution", "acad_plan", "acad_sub_plan", "effdt"]

Minor.effective.to_sql
=> "SELECT \"PS_ACAD_SUBPLN_TBL\".* FROM \"PS_ACAD_SUBPLN_TBL\" INNER JOIN (SELECT \"PS_ACAD_SUBPLN_TBL\".\"INSTITUTION\", \"PS_ACAD_SUBPLN_TBL\".\"ACAD_PLAN\", \"PS_ACAD_SUBPLN_TBL\".\"ACAD_SUB_PLAN\", MAX(\"PS_ACAD_SUBPLN_TBL\".\"EFFDT\") AS effdt FROM \"PS_ACAD_SUBPLN_TBL\"  WHERE (\"PS_ACAD_SUBPLN_TBL\".\"EFFDT\" <= TO_DATE('2014-12-03','YYYY-MM-DD HH24:MI:SS')) GROUP BY institution, acad_plan, acad_sub_plan) EFF_KEYS_PS_ACAD_SUBPLN_TBL ON \"PS_ACAD_SUBPLN_TBL\".\"INSTITUTION\" = EFF_KEYS_PS_ACAD_SUBPLN_TBL.\"INSTITUTION\" AND \"PS_ACAD_SUBPLN_TBL\".\"ACAD_PLAN\" = EFF_KEYS_PS_ACAD_SUBPLN_TBL.\"ACAD_PLAN\" AND \"PS_ACAD_SUBPLN_TBL\".\"ACAD_SUB_PLAN\" = EFF_KEYS_PS_ACAD_SUBPLN_TBL.\"ACAD_SUB_PLAN\" AND \"PS_ACAD_SUBPLN_TBL\".\"EFFDT\" = EFF_KEYS_PS_ACAD_SUBPLN_TBL.\"EFFDT\""
```

## `effective` scope

The `effective` scope, without arguments, will return only rows that are
effective as of today. This scope also accepts a date, which will return rows
that are effective as of that date.

## Example

```ruby
class College < ActiveRecord::Base
  extend PeoplesoftModels::AcadProgTbl
end

class EnrolledCollege < ActiveRecord::Base
  extend PeoplesoftModels::AcadProg

  belongs_to :college, -> { effective }, primary_key: College.primary_key, foreign_key: College.primary_key
end

class Student < ActiveRecord::Base
  extend PeoplesoftModels::Person

  has_many :enrolled_colleges, -> { effective }, primary_key: self.primary_key, foreign_key: self.primary_key
  has_many :colleges, through: :enrolled_colleges
end

student = Student.where(emplid: "1234567").first
student.colleges
```
## Required table permissions

This gem uses PeopleSoft's `PSRECDEFN` and `PSFIELD` tables to lookup up table
metadata. If access to your PeopleSoft instance is restricted, be sure to ask
for access to these tables.
