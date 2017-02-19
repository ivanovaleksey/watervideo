module Services
  module Video
    class Base
      attr_reader :video

      def initialize(params, video = nil)
        @params = params
        @video  = video
        @video  = define_video
      end

      def call
        if @video.save
          yield if block_given?
          true
        else
          # TODO: put some logic here
          false
        end
      end

      private

      def define_video
        raise NotImplementedError
      end

      def start_processing
        @video.process
      end

      def spawn_watermark_worker
        WatermarkWorker.perform_async(@video.id)
      end
    end
  end
end
