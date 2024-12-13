class AddStuffToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :title, :string
    add_column :events, :body, :text
    add_column :events, :date, :string
    add_column :events, :location, :text
  end
end
