class UserMailer < ActionMailer::Base
    default from: "Ultimate Bundles <customerservice@ultimate-bundles.com>"

    def signup_email(user)
        @user = user
        @twitter_message = "Take Control of Your Health! The Ultimate Healthy Living Bundle is Coming Soon. Tell your friends and get it free!"

        mail(:to => user.email, :subject => "The journey to perfect health starts here – bring your friends!")
    end
end
