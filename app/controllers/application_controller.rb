class ApplicationController < ActionController::API
	def render_404
		return {:status => '404'}
	end
	def render_200(obj)
		obj[:status] = 200
		return obj
	end
end
