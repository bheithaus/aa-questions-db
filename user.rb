class User
  attr_reader :id, :fname, :lname

  def self.find_by_name(fname, lname)
    query = <<-SQL
      SELECT *
      FROM users
      WHERE fname = ? AND lname = ?
    SQL

    response = DB.execute(query, fname, lname)[0]
    User.new(*response.values)
  end

  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
      FROM users
      WHERE id = ?
    SQL

    response = DB.execute(query, id)[0]
    User.new(*response.values)
  end

  def initialize(id, fname, lname, is_instructor)
    @id = id
    @fname = fname
    @lname = lname
    @is_instructor = is_instructor
  end

  def asked_questions
    Question.find_by_user_id(self.id)
  end

  def is_instructor
    @is_instructor == 1
  end

  def to_s
    "<User ##{id} #{fname} #{lname}>"
  end
end