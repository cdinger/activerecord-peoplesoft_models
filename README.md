# Peoplesoft Models for ActiveRecord

This Rubygem provides an easy way to build ActiveRecord models for reading
data from a PeopleSoft database.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-peoplesoft_models', '~> 1.0.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-peoplesoft_models

## Versions

- Version 1.x works with ActiveRecord 4.2
- Version 0.x works with ActiveRecord 4.1

## Usage

PeoplesoftModels works by dynamically constructing ActiveRecord classes for
accessing PeopleSoft tables. The model names are created under the
`PeoplesoftModels` namespace.

You can use these models directly:

```ruby
PeoplesoftModels::AcadSubplnTbl.first
```

Or subclass them to add your own associations, business logic, or just a more
meaningful name:

```ruby
class Minor < PeoplesoftModels::AcadSubplnTbl
end
```

These classes:

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
class College < PeoplesoftModels::AcadProgTbl
end

class EnrolledCollege < PeoplesoftModels::AcadProg
  belongs_to :college, -> { effective }, primary_key: College.primary_key, foreign_key: College.primary_key
end

class Student < PeoplesoftModels::Person
  has_many :enrolled_colleges, -> { effective }, primary_key: self.primary_key, foreign_key: self.primary_key
  has_many :colleges, through: :enrolled_colleges
end

student = Student.where(emplid: "1234567").first
student.colleges
```

## Using a different database connection

The `PeoplesoftModels::Base` class exists only as a convenient point for
changing the database connection used for accessing PeopleSoft tables. To use a
different connection, define an initializer in your app like this:

```ruby
# config/initializers/peoplesoft_models.rb
PeoplesoftModels::Base.establish_connection :"peoplesoft_#{Rails.env}"
```

## Schema prefixing

The `PeoplesoftModels::Base` class can also be configured to prefix the
`table_name` of any its subclassed models with the defined schema.

If your database setup requires you to prefix your tables like, say
`HCM.PS_JOB`, you can do this in an intitializer:

```ruby
# config/initializers/peoplesoft_models.rb
PeoplesoftModels::Base.schema_name = "HCM"
```

That'll cause any of its models to automatically prepend `HCM` like so:

```ruby
PeoplesoftModels::Job.table_name
=> "HCM.PS_JOB"
```

## Required table permissions

This gem uses PeopleSoft's `PSRECDEFN` and `PSRECFIELD` tables to lookup up table
metadata. If access to your PeopleSoft instance is restricted, be sure to ask
for access to these tables.

## Tests

`bundle exec rake test` runs the test suite. By default, tests that need
to hit a database run in an in-memory sqlite3 database.

You can optionally define other connections in `test/config/database.yml` and
use them by referencing a connection in the `DATABASE` environment variable.
Tests that alter the database are skipped if you specify a different
connection.

`DATABASE=peoplesoft_dev bundle exec rake test`

There's also a console available if you want to poke around a real instance of
PeopleSoft:

`DATABASE=peoplesoft_dev ./console`

## Motivation and principles

This library is the third crack at trying to solve this problem. The first two
iterations where huge, complex, and difficult to maintain. They required
the explicit definition of each individual model/keys and they required the
understanding of a thick layer of configuration in order to use them.

This take aims for simplicity. This thing is less than 100 lines of code and it
shouldn't need to grow much bigger than that. There's no wild configuration and
minimal magic. The goal is to do one thing, do it well, and get out of the
developer's way.
