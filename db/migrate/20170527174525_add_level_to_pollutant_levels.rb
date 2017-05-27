class AddLevelToPollutantLevels < ActiveRecord::Migration[5.0]
  def change
		add_column :pollutant_levels, :level, :string
  end
end
