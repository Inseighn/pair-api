class CreatePollutants < ActiveRecord::Migration[5.0]
  def change
    create_table :pollutants do |t|
      t.string :name
      t.string :param

      t.timestamps
    end
  end
end
