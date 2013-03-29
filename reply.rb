class Reply < Model
  attr_reader :parent, :body, :q_id, :user_id

  def initialize(options = {})
    @id = options['id']
    @parent = options['parent']
    @body = options['body']
    @q_id = options['q_id']
    @user_id = options['user_id']
  end

  def self.columns
    ['parent', 'body', 'q_id', 'user_id']
  end

  def self.table_name
    'question_replies'
  end

  def save
    save(parent, body, q_id, user_id)
  end

  def self.find_by_id(id)
    single_query(Reply, q(self.table_name, "id"), id)
  end

  def self.most_replied
    query = <<-SQL
      SELECT a.*
        FROM question_replies a JOIN question_replies b
          ON a.id = b.parent
       GROUP BY a.id
       ORDER BY COUNT(*) DESC
       LIMIT 1
    SQL

    single_query(Reply, query)
  end

  def replies
    #debugger
    Reply.multi_query(Reply, Reply.q(Reply.table_name, 'parent'), self.id)
  end

  def to_s
    "<Reply to Question ##{q_id}: #{body[0,20]}...>"
  end
end