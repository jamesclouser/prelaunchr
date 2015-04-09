class VideosController < ApplicationController

  def index
    @bodyId = 'videos'

    @video_id = 101
    if params.key?("video_id")
      @video_id = params[:video_id].to_i
    end

    email = cookies[:h_email]
    @user = User.find_by_email(email)
  end
end