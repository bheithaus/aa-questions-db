class Reply
  attr_reader :id, :parent, :body, :q_id, :user_id

  def self.most_replied
    query = <<-SQL
      SELECT a.*
      FROM question_replies a JOIN question_replies b
      ON a.id = b.parent
      GROUP BY a.id
      ORDER BY COUNT(*) DESC
      LIMIT 1
    SQL

    most_replied = DB.execute(query)[0]
    Reply.new(*most_replied.values)
  end

  def initialize(id, parent, body, q_id, user_id)
    @id = id
    @parent = parent
    @body = body
    @q_id = q_id
    @user_id = user_id
  end

  def replies
    query = <<-SQL
      SELECT *
      FROM question_replies
      WHERE parent = ?
    SQL
    replies = DB.execute(query, self.id)

    replies.map do |reply|
      Reply.new(*reply.values)
    end
  end

  def to_s
    "<Reply to Question ##{q_id}: #{body[0,20]}...>"
  end
end