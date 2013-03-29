class Model
	def self.table_name
		raise NotImplementedError.new
	end

	def self.find(id)
		response = DB.execute(<<-SQL, id)
			SELECT *
			  FROM #{table_name}
			  WHERE #{table_name}.id = ?
		SQL

		new(response.first)
	end

	def self.all
		response = DB.execute(<<-SQL)
			SELECT *
			FROM #{table_name}
		SQL

		response.map { |dat| new(dat) }
	end

	attr_reader :id

	def initialize(options = {})
		##take the column names sent in, make them strings
		##isn't this getting called from above? new(dat)..
		##guess not?
		options = options.each_with_object({}) { |(k, v), h| h[k.to_s] = v }

		@id = options['id']

		column_names.each do |column_name|
			self.send("#{column_name}=", options[column_name.to_s])
		end
	end

	def column_values
		column_names.map { |column_name| self.send(column_name) }
	end

	def create
		column_names_s = column_names.join(", ")
		question_marks_s = Array.new(column_names.count, "?").join(", ")

		query = <<-SQL
			INSERT INTO #{table_name} (#{column_names_s})
			VALUES (#{question_marks_s})
		SQL

		DB.execute(query, column_values)
		@id = DB.last_insert_row_id ###meh
	end

	def update
		sets = column_names.map do |column_name|
			"#{column_name} = ?"
		end.join(", ")

		query = <<-SQL
			UPDATE #{table_name}
			   SET #{sets}
			 WHERE id = ?
 		SQL

 		DB.execute(query, *column_values, id)
	end

	def save
		if @id
			update
		else
			create
		end
	end

private
	def self.attr_accessible(*column_names)
		@column_names = column_names.map { |column_name| column_name}

		@column_names.each do |column_name|
			attr_accessor column_name
		end
	end

	def self.column_names
		@column_names
	end 

	def column_names
		self.class.column_names
	end

	def table_name
		self.class.table_name
	end
end