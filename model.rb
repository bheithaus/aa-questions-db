class Model
	attr_reader :id

	def self.q(table_name,id)
		q = <<-SQL
			SELECT *
			FROM #{table_name}
			WHERE #{id} = ?
	    SQL
	end

	def self.single_query(cls, query, *args)
		params = DB.execute(query, *args)[0]
	    cls.new(params)
	end

	def self.multi_query(cls, query, *args)
		params_array = DB.execute(query, *args)
    	params_array.map {|params| cls.new(params) }
	end

	def self.save(*params)
	    if self.id
	      query = <<-SQL
	        UPDATE #{self.table_name}
	           SET #{self.columns.join(' = ?,')+" = ?,"}
	         WHERE id = ?
	      SQL
	      DB.execute(query, *params, self.id)
	    else
	      query = <<-SQL 
	      INSERT INTO users (#{self.columns.join(",")} ) 
	           VALUES (#{(["?"]*self.columns.count).join(",")}) 
	      SQL
	      DB.execute(query, *params)
	      @id = DB.last_insert_row_id()
	    end
	end

end