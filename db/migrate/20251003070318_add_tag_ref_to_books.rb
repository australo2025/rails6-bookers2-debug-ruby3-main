class AddTagRefToBooks < ActiveRecord::Migration[6.1]
  def change
    add_reference :books, :tag, foreign_key: true
  end
end
