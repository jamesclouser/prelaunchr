class VideosController < ApplicationController

  def index
    @bodyId = 'videos'

    @video_id = 101
    if params.key?("video_id")
      @video_id = params[:video_id].to_i
    end
  end
end