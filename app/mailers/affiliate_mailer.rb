class AffiliateMailer < ActionMailer::Base
    default from: "Ultimate Bundles <customerservice@ultimate-bundles.com>"

    def signup_email(user)
        @user = user
        @twitter_message = "Take Control of Your Health! The Ultimate Healthy Living Bundle is Coming Soon. Tell your friends. Earn Rewards."

        mail(:to => user.email, :subject => "Welcome Authors and Affiliates!")
    end
end
