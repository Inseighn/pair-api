Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	scope '/api' do
		get '/' => 'area#index'	
		scope '/:area' do
			get '/' => 'site#index'
			scope '/:site' do
				scope ':pollutant' do
				end
			end
		end
	end
	
end
