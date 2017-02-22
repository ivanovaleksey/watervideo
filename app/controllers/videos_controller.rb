class VideosController < ApplicationController
  include ActionController::Live

  before_action :load_video, only: [:file_state, :thumbnail_state]
  before_action :load_processed_video, only: [:show, :edit, :update]

  def index
    @videos = Video.order(created_at: :desc)
                   .page(params[:page])
                   .per(10)
                   .without_count
  end

  def new
    @video = Video.new
  end

  def create
    service = Services::Video::Create.new(create_params)
    if service.call
      flash[:notice] = I18n.t('videos.create.notice')
      redirect_to action: :index
    else
      @video = service.video
      flash[:error] = @video.errors.full_messages
      render action: :new
    end
  end

  def edit; end

  def update
    service = Services::Video::Update.new(update_params, @video)
    if service.call
      flash[:notice] = I18n.t('videos.update.notice')
      redirect_to action: :index
    else
      # TODO: do not raise
      @video = service.video
      flash[:error] = @video.errors.full_messages
      render action: :edit
      # raise
    end
  end

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

  def load_processed_video
    @video = Video.with_state(:processed).find(params[:id])
  end

  def create_params
    params.require(:video).permit(:file, :watermark_text)
  end

  def update_params
    params.require(:video).permit(:watermark_text)
  end

  def sse_action(options = {})
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream, options)
    yield sse
  ensure
    sse.close
  end
end
