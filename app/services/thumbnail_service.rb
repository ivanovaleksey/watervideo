class ThumbnailService
  def initialize(video)
    @video = video
  end

  def call
    Rails.logger.debug("ThumbnailService#call: #{@video.inspect}")

    tmp_file = capture_snapshot
    update_video(tmp_file)
  end

  private

  def capture_snapshot
    time = @video.movie.duration / 2
    tmp_file = Tempfile.new(%w(thumbnail .jpg), Rails.root.join('tmp')).path
    @video.movie.screenshot(tmp_file, seek_time: time).path
  end

  def update_video(thumbnail)
    Rails.logger.debug("ThumbnailService#update_video: #{thumbnail}")

    File.open(thumbnail) do |file|
      @video.update(thumbnail: file)
    end
  ensure
    Rails.logger.debug("ThumbnailService#update_video: Unlink #{thumbnail}")
    File.unlink(thumbnail)
  end
end
