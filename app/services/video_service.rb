class VideoService
  attr_reader :video

  def initialize(params)
    @video = Video.new(params)
    @video.assign_attributes(movie_attributes)
  end

  def create
    if @video.save
      spawn_watermark_worker
      true
    else
      # TODO: put some logic here
      false
    end
  end

  private

  def movie_attributes
    {
      duration: @video.movie.duration,
      size:     @video.movie.size
    }
  end

  def spawn_watermark_worker
    WatermarkWorker.perform_async(@video.id)
  end
end
