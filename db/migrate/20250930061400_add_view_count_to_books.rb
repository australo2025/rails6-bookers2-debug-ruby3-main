class AddViewCountToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :view_count, :integer, null: false, default: 0
  end
end
