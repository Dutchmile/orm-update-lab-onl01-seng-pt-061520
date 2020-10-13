require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

attr_accessor :name, :grade, :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade= grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT, grade TEXT)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end
  
  def save
    if self.id
      self.update
    else
    sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  end
  
  def self.create(name, grade)
    sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, name, grade)
  end
  
  def self.new_from_db(row)
    sql = <<-SQL
      SELECT * FROM students
      SQL
    DB[:conn].execute(sql).map do |row|
      new_student = self.new
      new_student.id = row[0]
      new_student.name = row[1]
      new_student.grade = row[2]
    end
  end
  
  
  def update
    sql = <<-SQL
    UPDATE students SET name = ?, grade = ?
    SQL
  DB[:conn].execute(sql, self.name, self.grade)
  end
  
  
  
end
