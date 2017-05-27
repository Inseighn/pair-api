module PairUtil::DB
	def self.update_sites_and_areas(current_table)
		areas = get_unique_col(current_table, 0)

		Area.delete_all
		areas.each do |area|
			Area.new(desc: area).save
		end
		Site.delete_all
		current_table.each do |row|
			if Area.exists?(desc: row[0])
				area_id = Area.find_by(desc: row[0]).id
				Site.new(desc: row[1], area_id: area_id).save
			end
		end
	end

	def self.update_pollutants
		Pollutant.delete_all
		pollutants = PairUtil::Updater.get_pollutants
		pollutants.each do |key, val|
			Pollutant.new(name: val, param: key).save
		end
	end

	def self.update_pollutant_levels(pollutant, date = "today")
		table = PairUtil::Updater.create_request(pollutant, date) 
		headers = PairUtil::Parser.get_headers(table)
		sites = PairUtil::Parser.get_unique_col(table, 1)
		now = DateTime.now 
		now = DateTime.parse(date) if !date.eql?("today")
		start_col = 2
		headers.each_with_index do |h,i|
			if i > start_col
				ts = nil
				time = Time.new(now.year, now.month, now.day, h)
				if h == "Noon"
					ts = DateTime.new(now.year, now.month, now.day, 12)
				elsif i > 14
					ts = DateTime.new(now.year, now.month, now.day, (time + 43200).hour) 
				else
					ts = DateTime.new(now.year, now.month, now.day, time.hour)
				end
				pol_id = Pollutant.find_by(param: pollutant).id
				if !pol_id.nil?
					sites.each_with_index do |site,ii|
						site_id = Site.find_by(desc: site).id
						if !site_id.nil?
							lvl = nil
						 	if PollutantLevel.exists?(pollutant_id: pol_id, site_id: site_id, time: ts)
								lvl = PollutantLevel.find_by(pollutant_id: pol_id, site_id: site_id, time: ts)
							end
							if lvl.nil?
								PollutantLevel.new(pollutant_id: pol_id, site_id: site_id, time: ts, level: table[ii][i]).save
							elsif !lvl.nil?
								lvl.level = table[ii + 1][i]
								lvl.save	
							else
							end
						end
					end
				end
			end
		end
	end
end
