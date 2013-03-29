module Query_helper


	def Query_helper.single_query(cls, query, *args)
		params = DB.execute(query, *args)[0]
	    cls.new(params)
	end

	def Query_helper.multi_query(cls, query, *args)
		params_array = DB.execute(query, *args)
    	params_array.map {|params| cls.new(params) }
	end
end
