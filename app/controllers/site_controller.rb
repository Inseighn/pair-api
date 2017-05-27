class SiteController < ApplicationController
	def index
		updater = Updater.new
		render json: updater.get_sites.to_json
	end
end
