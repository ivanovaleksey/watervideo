class WatermarkWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(video_id)
    Rails.logger.debug("WatermarkWorker#perform: #{video_id}")

    video = Video.find(video_id)
    service = WatermarkService.new(video)
    service.call
  end
end
