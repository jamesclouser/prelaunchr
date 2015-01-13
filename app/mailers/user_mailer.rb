class UserMailer < ActionMailer::Base
    default from: "UltimateBundles <customerservice@ultimate-bundles.com>"

    def signup_email(user)
        @user = user
        @twitter_message = "I just rediscovered my inner creative genius. Wanna join me? Plus, earn 1yr of Better Homes and Gardens for FREE."

        mail(:to => user.email, :subject => "Your 4-steps mini-course")
    end
end
