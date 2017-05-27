class Site < ApplicationRecord
  belongs_to :area
	has_many :pollutant_levels
	has_many :pollutants, through: :pollutant_levels 
end
