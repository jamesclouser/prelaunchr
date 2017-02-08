module QuizHelper
  def category_score(category)
	score = 0

	@results['data'][category].each do |question|
		score += question['answer'].to_f
	end

	(score / 12) * 100
  end

  def total_score()
	score = 0

	@results['data'].each_key do |category|
		if category != 'email' and category != 'token'
			@results['data'][category].each do |question|
				score += question['answer'].to_f
			end
		end
	end

	(score / 72) * 100
  end
end
