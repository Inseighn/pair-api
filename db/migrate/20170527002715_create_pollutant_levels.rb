class CreatePollutantLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :pollutant_levels do |t|
      t.references :site, foreign_key: true
      t.references :pollutant, foreign_key: true
      t.timestamp :time

      t.timestamps
    end
  end
end
