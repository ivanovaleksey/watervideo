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
    # TODO: errors handling
    service = VideoService.new(create_params)
    service.create
    redirect_to action: :index
  end

  def edit; end

  def update
    # TODO: regenerate watermark
    @video.update(update_params)
    redirect_to action: :index
  end

  private

  def load_video
    @video = Video.find(params[:id])
  end

  def create_params
    params.require(:video).permit(:file, :watermark_text)
  end

  def update_params
    params.require(:video).permit(:watermark_text)
  end
end
