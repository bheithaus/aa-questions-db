

class User

  attr_reader :id
  attr_accessor :fname, :lname, :is_instructor

  def self.find_by_name(fname, lname)
    query = <<-SQL
      SELECT *
        FROM users
       WHERE fname = ? AND lname = ?
    SQL

    Query_helper.single_query(User, query, fname, lname)
  end

  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
        FROM users
       WHERE id = ?
    SQL

    Query_helper.single_query(User, query, id)
  end

  def initialize(options = {})
    @id = options['id'] || nil
    @fname = options['fname']
    @lname = options['lname']
    @is_instructor = options['is_instructor']
  end

  def asked_questions
    Question.find_by_user_id(self.id)
  end

  def save
    if self.id
      query = <<-SQL
        UPDATE users
           SET fname = ?, lname = ?, is_instructor = ?
         WHERE id = ?
      SQL
      DB.execute(query, fname, lname, is_instructor, self.id)
    else
      query = <<-SQL 
      INSERT INTO users (fname,lname,is_instructor) 
           VALUES (?,?,?) 
      SQL
      DB.execute(query, fname, lname, is_instructor)
      @id = DB.last_insert_row_id()
    end
  end

  def average_karma

  end

  def to_s
    "<User ##{id} #{fname} #{lname}>"
  end
end