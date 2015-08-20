class LessonsController < ApplicationController

  def index
    @bodyId = 'lessons'

    @lesson_id = 101
    if params.key?("lesson_id")
      @lesson_id = params[:lesson_id].to_i
    end

    email = cookies[:h_email]
    @user = User.find_by_email(email)
  end
end