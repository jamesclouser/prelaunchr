class UserMailer < ActionMailer::Base
    default from: "Ultimate Bundles <customerservice@ultimate-bundles.com>"

    def signup_email(user)
        @user = user
        mail(:to => user.email, :subject => "Access confirmed: Discover your Photography Strengths score!")
    end
end
