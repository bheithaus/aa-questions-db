require './model'

class User < Model

  attr_accessor :fname, :lname, :is_instructor

  def initialize(options = {})
    @id = options['id'] || nil
    @fname = options['fname']
    @lname = options['lname']
    @is_instructor = options['is_instructor']
  end

  def self.columns
    ['id', 'fname', 'lname', 'is_instructor']
  end

  def self.table_name
    'users'
  end

  def self.find_by_name(fname, lname)
    query = <<-SQL
      SELECT *
        FROM users
       WHERE fname = ? AND lname = ?
    SQL

    single_query(User, query, fname, lname)
  end

  def self.find_by_id(id)
    single_query(User, q(self.table_name,'id'), id)
  end

  def asked_questions
    Question.find_by_user_id(self.id)
  end

  def save
    save(fname,lname,is_instructor)
  end

  def average_karma

  end

  def to_s
    "<User ##{id} #{fname} #{lname}>"
  end
end
