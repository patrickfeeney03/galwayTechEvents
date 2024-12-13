class AddRelationToComment < ActiveRecord::Migration[8.0]
  def change
    add_reference :comments, :event, null: false, foreign_key: true
  end
end
