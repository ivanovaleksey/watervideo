class AddStateToVideos < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :state, :string
  end
end
