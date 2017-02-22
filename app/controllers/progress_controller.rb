class ProgressController < ApplicationController
  include ActionController::Live

  before_action :load_video, only: [:file_state, :thumbnail_state]

  def file_state
    sse_action do |sse|
      sse.write(@video.state)
    end
  end

  def thumbnail_state
    sse_action(retry: 1_000) do |sse|
      sse.write(@video.thumbnail.url)
    end
  end

  private

  def load_video
    @video = Video.find(params[:id])
  end

  def sse_action(options = {})
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream, options)
    yield sse
  ensure
    sse.close
  end
end
