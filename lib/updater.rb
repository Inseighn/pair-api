require 'mechanize'

class Updater
	TCEQ_UPDATE_URL = "https://www.tceq.texas.gov/cgi-bin/compliance/monops/agc_daily_average.pl"
	AREA_COL = 0
	SITE_COL = 1
	
	@@req_params = { :select_date => "", :user_month => "", :user_day => "", :user_year => "", :user_param => "", :user_units => "ppb-v", :report_format => "comma" }

	def get_pollutants 
		agent = Mechanize.new
		body = agent.get(TCEQ_UPDATE_URL)

		pollutants_list = body.search('//select[@name="user_param"]')

		n_pollutants = {}
		pollutants_list.children.each do |p|
			if p.has_attribute?("value")
				key = p.attr(:value).to_sym
				n_pollutants[key] = p.inner_text.strip
			end			

		end
		return n_pollutants
	end

	def create_request(pollutant = "45201", date = "today", location = "")
		post_params = @@req_params.clone

		if date == "today"
			current_date = Time.now
			if post_params == nil
				puts "WTF"
			end
			post_params[:select_date] = "user"
			post_params[:user_month] = (current_date.month - 1).to_s
			post_params[:user_day] = current_date.day.to_s
			post_params[:user_year] = current_date.year.to_s
		end
		
		post_params[:user_param] = pollutant
		make_request(post_params)
	end

	def make_request (post_params)
		agent = Mechanize.new
		uri = URI(TCEQ_UPDATE_URL)
		body = agent.post(uri, post_params)
		table = body.search("//pre")
		if table.children.any?
			parse_table_data(table)
		end
	end

	def parse_table_data(table_node)
			table_lines = table_node.children.first.text.lines
			table_data = [] 
			table_lines.each do |line|
				line_data = [] 
				line_cols = line.split(",")
				if line_cols.count > 3
					line_cols.each do |col|
						line_data.push(col.strip)
					end
					table_data.push(line_data) 
				end
			end
			return table_data
	end

	def get_areas
		return get_unique_col(0)
	end
	def get_sites
		return get_unique_col(1)
	end

	def get_unique_col(col)
		current_table = create_request
		areas = []
		puts "Retrieved table with #{current_table.count} rows."
		current_table.each_index do |i|
			if i > 0
				areas.push(current_table[i][col])
			end
		end
	  return areas if areas.uniq! == nil
		return areas.uniq! 
	end
end

