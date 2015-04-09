module VideosHelper
  def video_url(video_id)
    case video_id
    when 101
      "123675247"
    when 102
      "123675253"
    when 103
      "123675248"
    when 104
      "123996823"
    end
  end
end
