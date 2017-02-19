class VideosController < ApplicationController
  before_action :load_video, only: [:show, :edit, :update]

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

  private

  def load_video
    @video = Video.with_state(:processed).find(params[:id])
  end

  def create_params
    params.require(:video).permit(:file, :watermark_text)
  end

  def update_params
    params.require(:video).permit(:watermark_text)
  end
end
