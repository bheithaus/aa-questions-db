require 'singleton'
require 'sqlite3'

class QuestionDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("questions.db")
    self.results_as_hash = true
    self.type_translation = true
  end
end

DB ||= QuestionDatabase.instance

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

  def self.find_by_id(fname, lname)
    query = <<-SQL
      SELECT *
      FROM users
      WHERE fname = ? AND lname = ?
    SQL

    response = DB.execute(query, fname, lname)[0]
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

class Question
  attr_reader :id, :title, :body, :user_id, :num_follow, :likes
  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
      FROM questions
      WHERE id = ?
    SQL
    question = DB.execute(query, id)[0]

    Question.new(*question.values)
  end

  def self.find_by_user_id(user_id)
    query = <<-SQL
      SELECT *
      FROM questions
      WHERE user_id = ?
    SQL
    questions = DB.execute(query, user_id)

    questions.map do |question|
      Question.new(*question.values)
    end
  end

  def self.most_followed(n)
    query = <<-SQL
      SELECT q.*, COUNT(f.question_id)
      FROM questions q JOIN question_followers f
      ON q.id = f.question_id
      GROUP BY f.question_id
      ORDER BY COUNT(f.question_id) DESC
      LIMIT ?
    SQL
    most_followed = DB.execute(query, n)

    most_followed.map do |question|
      Question.new(*question.values)
    end
  end

  def initialize(id, title, body,
                  user_id, num_follow = 0, likes = 0)
    @id = id
    @title = title
    @body = body
    @user_id = user_id
    @num_follow = num_follow
    @likes = likes
  end

  def asking_student
    Users.find_by_id(user_id)
  end

  def followers
    query = <<-SQL
      SELECT users.*
        FROM users JOIN question_followers
        ON users.id = question_followers.follower_id
        JOIN questions
        ON questions.id = question_followers.question_id
        WHERE questions.id = ?
      SQL
    followers = DB.execute(query, id)
  end

  def to_s
    "<Question ##{id} #{title} followers: #{num_follow}>"
  end

end

