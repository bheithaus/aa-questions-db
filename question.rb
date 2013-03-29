class Question
  attr_reader :id, :title, :body, :user_id, :likes
  attr_writer :num_follow

  def num_follow
    @num_follow.count
  end

  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
        FROM questions
       WHERE id = ?
    SQL

    Query_helper.single_query(Question, query, id)
  end

  def self.find_by_user_id(user_id)
    query = <<-SQL
      SELECT *
        FROM questions
       WHERE user_id = ?
    SQL

    Query_helper.multi_query(Question, query, user_id)
  end

  def self.most_followed(n)
    query = <<-SQL
      SELECT q.*, COUNT(f.question_id) as followers
        FROM questions q JOIN question_followers f
          ON q.id = f.question_id
       GROUP BY f.question_id
       ORDER BY COUNT(f.question_id) DESC
       LIMIT ?
    SQL

    Query_helper.multi_query(Question, query, n)
  end

  def self.most_liked(n)
    query = <<-SQL
      SELECT q.*, COUNT(*) AS num_likes
        FROM questions q JOIN question_like l
          ON q.id = l.question_id
       GROUP BY q.id
       ORDER BY COUNT(*) DESC
       LIMIT ?
     SQL

    Query_helper.multi_query(Question, query, n)
  end

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
    @num_follow = options['num_follow'] || self.followers
    @likes = options['likes'] || self.num_likes
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

    Query_helper.multi_query(User, query, id)
  end

  def num_likes
    query = <<-SQL
      SELECT count(*) AS num_likes
        FROM question_like
       WHERE question_id = ?
    SQL

    DB.execute(query, id)[0]['num_likes']
  end

  def to_s
    "<Question ##{id} #{title} followers: #{num_follow} likes: #{likes}>"
  end
end