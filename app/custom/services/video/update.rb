module Services
  module Video
    class Update < Base
      def call
        super do
          start_processing
          spawn_watermark_worker
        end
      end

      private

      def define_video
        @video.tap do |v|
          v.assign_attributes(@params)
        end
      end
    end
  end
end
