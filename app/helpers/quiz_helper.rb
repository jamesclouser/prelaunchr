module QuizHelper
  def category_score(response, category)
	score = 0

	response['data'][category].each do |question|
		score += question['answer'].to_f
	end

	(score / 12) * 100
  end

  def total_score(response)
	score = 0

	response['data'].each_key do |category|
		if category != 'email' and category != 'token'
			response['data'][category].each do |question|
				score += question['answer'].to_f
			end
		end
	end

	(score / 72) * 100
  end
end
