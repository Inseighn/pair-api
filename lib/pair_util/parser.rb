module PairUtil::Parser
	def self.get_headers(table)
		return table.first 
	end

	def self.get_col_by_header(table, header)
		header_index = 0
		get_headers(table).each_with_index do |h,i|
			if h == header
				header_index = i
			end
		end
		return get_unique_col(table, header_index)
	end

	def self.get_col(current_table, col)
		areas = []
		current_table.each_index do |i|
			if i > 0
				areas.push(current_table[i][col])
			end
		end
		return areas
	end

	def self.get_unique_col(current_table, col)
		col_vals = get_col(current_table, col)
		return col_vals.uniq if !col_vals.uniq.nil?
		return col_vals
	end

end
