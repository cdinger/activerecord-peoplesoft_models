class FakePeoplesoft
  def self.create!
    create_tables
  end

  def self.create_tables
    statements = IO.read(File.join(File.dirname(__FILE__), 'fake_peoplesoft.sql')).split(';')
    statements.each do |statement|
      PeoplesoftModels::Base.connection.execute(statement) unless statement.blank?
    end
  end
end
