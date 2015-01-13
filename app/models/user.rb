class User < ActiveRecord::Base
    belongs_to :referrer, :class_name => "User", :foreign_key => "referrer_id"
    has_many :referrals, :class_name => "User", :foreign_key => "referrer_id"

    attr_accessible :name, :email, :infusionsoft_affiliate_link

    validates :email, :uniqueness => true, :format => { :with => /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i, :message => "Invalid email format." }
    validates :referral_code, :uniqueness => true
    validates :name, presence: true

    before_create :create_referral_code
    after_create :send_welcome_email

    REFERRAL_STEPS = [
        {
            'count' => 1,
            "html" => "$5 Off<br>Ultimate DIY Ultimate Bundle 2015",
            "class" => "two",
            "image" =>  "creativity/reward1.jpg"
        },
        {
            'count' => 5,
            "html" => "1-Year Subscription<br>to Better Homes and Gardens<br>",
            "class" => "three",
            "image" => "creativity/reward2.jpg"
        },
        {
            'count' => 10,
            "html" => "FREE<br>Ultimate DIY Bundle 2015<br>($34.95 Value)",
            "class" => "four",
            "image" => "creativity/reward3.jpg"
        }
    ]

    def add_to_infusionsoft
      contact_id = Infusionsoft.contact_add_with_dup_check({:FirstName => self.name, :Email => self.email}, 'Email');
      if contact_id
        Kernel.sleep(0.3)
        Infusionsoft.contact_add_to_group(contact_id, 1208)
        Kernel.sleep(0.3)
        Infusionsoft.email_optin(@user.email, "RAF App Opt-In")
      end
    end

    def infusionsoft_referral
      contact = Infusionsoft.contact_find_by_email(self.email, ['id'])
      Kernel.sleep(0.3)
      Rails.logger.debug '------------ CALLING INFUSIONSOFT'
      Rails.logger.debug self.email
      Rails.logger.debug contact.inspect

      if contact.count > 0 && self.referrals.count == 1
        ifs_result = Infusionsoft.contact_add_to_group(contact[0]["id"], 1216)
      elsif contact.count > 0 && self.referrals.count == 5
        ifs_result = Infusionsoft.contact_add_to_group(contact[0]["id"], 1218)
      elsif contact.count > 0 && self.referrals.count == 10
        ifs_result = Infusionsoft.contact_add_to_group(contact[0]["id"], 1220)
      end

      Rails.logger.debug ifs_result
      Rails.logger.debug '------------ END INFUSIONSOFT'
    end
    
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
      if (self.referrer_id && self.referrer_id > 0) || self.infusionsoft_affiliate_link.blank?
        UserMailer.delay.signup_email(self)
      else
        AffiliateMailer.delay.signup_email(self)
      end
    end
end
