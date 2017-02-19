class ThumbnailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(video_id)
    Rails.logger.debug("ThumbnailWorker#perform: #{video_id}")

    video = Video.find(video_id)
    service = Services::Thumbnail.new(video)
    service.call
  end
end
