class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.timestamps
    end
  end
end