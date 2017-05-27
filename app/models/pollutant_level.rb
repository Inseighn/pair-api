class PollutantLevel < ApplicationRecord
  belongs_to :site
  belongs_to :pollutant
end
