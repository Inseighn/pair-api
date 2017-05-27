require 'json'
class AreaController < ApplicationController
	def index
		Area.delete_all
		if Area.all.empty?
			updater = Updater.new
			areas = updater.get_areas
			areas.each do |area|
				Area.new(desc: area).save
			end
		end
		areas = {}
		Area.all.each do |area|
			areas[area.id] = {:id => area.id, :desc => area.desc} 
		end
		render json: areas.to_json
	end
end
