class UserMailer < ActionMailer::Base
    default from: "Ultimate Bundles <customerservice@ultimate-bundles.com>"

    def signup_email(user)
        @user = user
        @twitter_message = "I just rediscovered my inner creative genius. Wanna join me? Plus, earn 1yr of Better Homes and Gardens for FREE."

        mail(:to => user.email, :subject => "Get ready to connect with your creative side in 2015 – and bring your friends!")
    end
end
