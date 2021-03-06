class User < ActiveRecord::Base
  belongs_to :referrer, :class_name => "User", :foreign_key => "referrer_id"
  has_many :referrals, :class_name => "User", :foreign_key => "referrer_id"

  validates :email, :uniqueness => true, :format => { :with => /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i, :message => "Invalid email format." }
  validates :referral_code, :uniqueness => true
  validates :name, presence: true

  before_create :create_referral_code
  #after_create :send_welcome_email

  REFERRAL_STEPS = [
    {
      'count' => 1,
      "html" => "$5 Off<br>The Ultimate Homemaking Bundle",
      "class" => "two",
      "image" =>  "homemaker/reward-1.jpg"
    },
    {
      'count' => 5,
      "html" => "1-Year Subscription<br>to Better Homes and Gardens<br>",
      "class" => "three",
      "image" => "creativity/reward2.jpg"
    },
    {
      'count' => 10,
      "html" => "FREE<br>Ultimate Homemaking Bundle<br>($34.95 Value)",
      "class" => "four",
      "image" => "homemaker/reward-3.jpg"
    }
  ]

  def add_to_infusionsoft
    Rails.logger.info '------------ CALLING INFUSIONSOFT contact_add_with_dup_check'
    contact_id = Infusionsoft.contact_add_with_dup_check({:FirstName => self.name, :Email => self.email}, 'Email');
    Rails.logger.info contact_id
    if contact_id
      Kernel.sleep(0.3)
      group_result = Infusionsoft.contact_add_to_group(contact_id, 2112)
      Rails.logger.info group_result
      Kernel.sleep(0.3)
      optin_result = Infusionsoft.email_optin(self.email, "RAF App Opt-In")
      Rails.logger.info optin_result
    end
    Rails.logger.info '------------ END INFUSIONSOFT'
  end

  def infusionsoft_referral
    contact = Infusionsoft.contact_find_by_email(self.email, ['id'])
    Kernel.sleep(0.3)
    Rails.logger.info '------------ CALLING INFUSIONSOFT'
    Rails.logger.info self.email
    Rails.logger.info contact.inspect

    if contact.count > 0 && self.referrals.count == 1
      ifs_result = Infusionsoft.contact_add_to_group(contact[0]["id"], 1462)
    elsif contact.count > 0 && self.referrals.count == 5
      ifs_result = Infusionsoft.contact_add_to_group(contact[0]["id"], 1464)
    elsif contact.count > 0 && self.referrals.count == 10
      ifs_result = Infusionsoft.contact_add_to_group(contact[0]["id"], 1466)
    end

    Rails.logger.info ifs_result
    Rails.logger.info '------------ END INFUSIONSOFT'
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
    #if (self.referrer_id && self.referrer_id > 0) || self.infusionsoft_affiliate_link.blank?
    UserMailer.delay.signup_email(self)
    #end
  end
end
