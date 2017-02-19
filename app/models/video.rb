class Video < ApplicationRecord
  mount_uploader :file, VideoFileUploader
  mount_uploader :thumbnail, ThumbnailUploader

  delegate :height, :width, to: :movie

  validates :file, :watermark_text, presence: true

  state_machine initial: :pending do
    event :process do
      transition [:pending, :processed] => :processing
    end

    event :complete do
      transition processing: :processed
    end
  end

  def movie
    path = file.current_path
    return nil unless path
    FFMPEG::Movie.new(path)
  end
end
