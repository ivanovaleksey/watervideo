module Services
  class Watermark
    def initialize(video)
      @video = video
    end

    def call
      Rails.logger.debug("Watermark#call: #{@video.inspect}")

      tmp_file = generate_image
      apply_watermark(tmp_file)
      finish_processing
    end

    private

    def generate_image
      args = {
        height: @video.height,
        width:  @video.width,
        text:   @video.watermark_text
      }
      service = Image.new(args)
      service.call
    end

    def apply_watermark(image)
      Rails.logger.debug("Watermark#apply_watermark: #{image}")

      options = {
        watermark: image,
        watermark_filter: { position: 'LT', padding_x: 0, padding_y: 0 }
      }

      @video.movie.transcode(file_path, options) do |progress|
        Rails.logger.debug("Progress: #{progress}")
      end
    ensure
      Rails.logger.debug("Watermark#apply_watermark: Unlink #{image}")
      File.unlink(image) if File.exist?(image)
    end

    def finish_processing
      @video.complete
    end

    def file_path
      @video.file.watermark.current_path.tap do |path|
        Rails.logger.debug("Watermark#file_path: #{path}")
      end
    end
  end
end
