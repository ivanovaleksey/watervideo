class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.string :file
      t.string :watermark_text

      t.float   :duration
      t.integer :size
    end
  end
end
