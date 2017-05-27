require 'mechanize'
require 'pair_util'
module PairUtil::Updater
	TCEQ_UPDATE_URL = "https://www.tceq.texas.gov/cgi-bin/compliance/monops/agc_daily_average.pl"
	AREA_COL = 0
	SITE_COL = 1
	@@req_params = { :select_date => "", :user_month => "", :user_day => "", :user_year => "", :user_param => "", :user_units => "ppb-v", :report_format => "comma" }

	def self.get_pollutants 
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

	def self.create_request(pollutant = "45201", date = "today", location = "")
		post_params = @@req_params.clone

		post_params[:select_date] = "user"
		if date == "today"
			current_date = Time.now
			post_params[:user_month] = (current_date.month - 1).to_s
			post_params[:user_day] = current_date.day.to_s
			post_params[:user_year] = current_date.year.to_s
		else
			t = Time.parse(date)
			if !t.nil?
				post_params[:user_month] = (t.month - 1).to_s
				post_params[:user_day] = t.day.to_s
				post_params[:user_year] = t.year.to_s
			else
				puts "Unable to parse date: #{date}"
			end
		end
		post_params[:user_param] = pollutant.to_s
		puts post_params
		make_request(post_params)
	end

	def self.make_request (post_params)
		agent = Mechanize.new
		uri = URI(TCEQ_UPDATE_URL)
		body = agent.post(uri, post_params)
		table = body.search("//pre")
		if table.children.any?
			parse_table_data(table)
		end
	end

	def self.parse_table_data(table_node)
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
end
