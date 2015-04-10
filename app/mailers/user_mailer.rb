class UserMailer < ActionMailer::Base
    default from: "UltimateBundles <customerservice@ultimate-bundles.com>"

    def signup_email(user)
        @user = user
        mail(:to => user.email, :subject => "Your Mini Video-eCourse")
    end
end
