class User
  attr_reader :id
  attr_accessor :fname, :lname, :is_instructor

  def self.find_by_name(fname, lname)
    query = <<-SQL
      SELECT *
      FROM users
      WHERE fname = ? AND lname = ?
    SQL

    response = DB.execute(query, fname, lname)[0]
    User.new(response)
  end

  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
      FROM users
      WHERE id = ?
    SQL

    response = DB.execute(query, id)[0]
    User.new(response)
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

  # def is_instructor
  #   @is_instructor == 1
  # end

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
        INSERT INTO users
        (fname,lname,is_instructor)
        VALUES (?,?,?)
      SQL
      DB.execute(query, fname, lname, is_instructor)
      @id = DB.last_insert_row_id()
    end
  end

  def average_karma
    ## total likes / total num of questions

    query = <<-SQL
      SELECT COUNT(l.question_id) AS questions, COUNT(q.id) AS karma, COUNT(l.question_id)/(COUNT(q.id)*1.0) AS avg
      FROM questions q JOIN question_like l
      on q.id = l.question_id
      WHERE q.user_id = ?
    SQL
    ave = DB.execute(query, id)

  end

  def to_s
    "<User ##{id} #{fname} #{lname}>"
  end
end