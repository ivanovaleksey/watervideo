class VideosController < ApplicationController
  before_action :load_video, only: [:show, :edit, :update]

  def index
    @videos = Video.order(created_at: :desc)
                   .page(params[:page])
                   .per(params[:per])
  end

  def new
    @video = Video.new
  end

  def create
    service = Services::Video.new(create_params)
    if service.create
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
    # TODO: regenerate watermark
    @video.update(update_params)
    redirect_to action: :index
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
