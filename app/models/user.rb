class User < ActiveRecord::Base
    belongs_to :referrer, :class_name => "User", :foreign_key => "referrer_id"
    has_many :referrals, :class_name => "User", :foreign_key => "referrer_id"

    attr_accessible :name, :email, :infusionsoft_affiliate_link

    validates :email, :uniqueness => true, :format => { :with => /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i, :message => "Invalid email format." }
    validates :referral_code, :uniqueness => true

    before_create :create_referral_code
    after_create :send_welcome_email

    REFERRAL_STEPS = [
        {
            'count' => 1,
            "html" => "$7 Off<br>the Bundle",
            "class" => "two",
            "image" =>  "refer/hover1.jpg"
        },
        {
            'count' => 5,
            "html" => "12 Week<br>Audio Course",
            "class" => "three",
            "image" => "refer/hover2.jpg"
        },
        {
            'count' => 10,
            "html" => "Healthy Living<br>Bundle",
            "class" => "four",
            "image" => "refer/hover3.jpg"
        }
    ]

    private

    def create_referral_code
        referral_code = SecureRandom.hex(5)
        @collision = User.find_by_referral_code(referral_code)

        while !@collision.nil?
            referral_code = SecureRandom.hex(5)
            @collision = User.find_by_referral_code(referral_code)
        end

        self.referral_code = referral_code
    end

    def send_welcome_email
        UserMailer.delay.signup_email(self)
    end
end
