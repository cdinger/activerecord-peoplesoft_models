#require 'dept_tbl'

class Job < ActiveRecord::Base
  extend PeoplesoftModels::Job

  #belongs_to :effective_dept_tbl, -> { effective }, class_name: "DeptTbl", primary_key: [:setid, :deptid], foreign_key: [:setid_dept, :deptid]
end
