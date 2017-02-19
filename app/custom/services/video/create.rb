module Services
  module Video
    class Create < Base
      def call
        super do
          start_processing
          spawn_thumbnail_worker
          spawn_watermark_worker
        end
      end

      private

      def define_video
        ::Video.new(@params).tap do |v|
          v.assign_attributes(movie_attributes(v))
        end
      end

      def movie_attributes(video)
        movie = video.movie
        return {} unless movie
        {
          duration: movie.duration,
          size:     movie.size
        }
      end

      def spawn_thumbnail_worker
        ThumbnailWorker.perform_async(@video.id)
      end
    end
  end
end
