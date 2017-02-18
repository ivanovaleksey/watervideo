class Video < ApplicationRecord
  mount_uploader :file, VideoFileUploader

  delegate :height, :width, to: :movie

  def movie
    @movie ||= FFMPEG::Movie.new(file.current_path)
  end
end
