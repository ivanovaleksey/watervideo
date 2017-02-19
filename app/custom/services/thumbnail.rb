module Services
  class Thumbnail
    def initialize(video)
      @video = video
    end

    def call
      Rails.logger.debug("Thumbnail#call: #{@video.inspect}")

      tmp_file = capture_snapshot
      create_thumbnail(tmp_file)
      update_video(tmp_file)
    end

    private

    def capture_snapshot
      movie = @video.movie
      time = movie.duration / 2
      tmp_file = Tempfile.new(%w(thumbnail .jpg), Rails.root.join('tmp')).path
      movie.screenshot(tmp_file, seek_time: time).path
    end

    def create_thumbnail(tmp_file)
      snapshot = Magick::Image.read(tmp_file).first
      thumb = snapshot.scale(726, 453.75)
      thumb.write(tmp_file)
    end

    def update_video(thumbnail)
      Rails.logger.debug("Thumbnail#update_video: #{thumbnail}")

      File.open(thumbnail) do |file|
        @video.update(thumbnail: file)
      end
    ensure
      Rails.logger.debug("Thumbnail#update_video: Unlink #{thumbnail}")
      File.unlink(thumbnail) rescue Errno::ENOENT
    end
  end
end
