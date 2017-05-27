class SiteController < ApplicationController
	def index
		if params.has_key?(:area)
			sites = {}
			if !Area.exists?(id: params[:area])
				render json: render_404
				return
			end
			Area.find(params[:area]).sites.each_with_index do |site, i|
				sites[i] = {:id => site.id, :desc => site.desc}
			end
			render json: render_200(sites) 
		end
	end
end
