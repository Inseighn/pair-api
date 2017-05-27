require 'json'
class AreaController < ApplicationController
	def index
		areas = {}
		Area.all.each_with_index do |area, i|
			areas[i] = {:id => area.id, :desc => area.desc} 
		end
		render json: areas
	end
	
end
