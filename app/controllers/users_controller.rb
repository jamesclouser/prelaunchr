class UsersController < ApplicationController
  helper QuizHelper
  before_filter :skip_first_page, :only => :new

  def index
    @users = []
    User.all.each do |user|
      if user.referrals.count >= 1 && user.referrals.count < 5
        @users << user
      end
    end
  end

  def new
    @bodyId = 'home'
    @is_mobile = mobile_device?

    @user = User.new

    @ip_limit = false

    if params.has_key?(:ip_limit)
      @ip_limit = false
    end

    if Time.now.to_i > Time.parse("2017-02-28 00:00:00 -0800").to_i
      redirect_to "https://ultimate-bundles.com"
    else
      respond_to do |format|
        format.html # new.html.erb
      end
    end
  end

  def create
    unless params.has_key?(:user) && params[:user][:email] != '' && params[:user][:name] != ''
      return redirect_to :action => "new"
    end

    # Get user to see if they have already signed up
    @user = User.find_by_email(params[:user][:email]);

    # If user doesnt exist, make them, and attach referrer
    if @user.nil?

      cur_ip = IpAddress.find_by_address(request.env['HTTP_X_FORWARDED_FOR'])

      if !cur_ip
        cur_ip = IpAddress.create(
          :address => request.env['HTTP_X_FORWARDED_FOR'],
          :count => 0
        )
      end

      if cur_ip.count > 2 
        return redirect_to :action => "new", :ip_limit => true
      else
        cur_ip.count = cur_ip.count + 1
        cur_ip.save
      end

      @user = User.new(:email => params[:user][:email], :name => params[:user][:name].titleize)

      @referred_by = User.find_by_referral_code(cookies[:h_ref])

      puts '------------'
      puts @referred_by.email if @referred_by
      puts params[:user][:email].inspect
      puts request.env['HTTP_X_FORWARDED_FOR'].inspect
      puts '------------'

      if !@referred_by.nil?
        @user.referrer = @referred_by
        @user.infusionsoft_affiliate_link = @referred_by.infusionsoft_affiliate_link
      end

      @user.name = @user.name.titleize
      @user.save

      if @referred_by
        @referred_by.delay.infusionsoft_referral
        #contact = Infusionsoft.contact_find_by_email(@referred_by.email, ['id'])
        #puts '------------ CALLING INFUSIONSOFT'
        #puts @referred_by.email
        #puts contact.inspect

        #if contact.count > 0 && @referred_by.referrals.count == 1
        #  ifs_result = Infusionsoft.contact_add_to_group(contact[0]["id"], 1216)
        #elsif contact.count > 0 && @referred_by.referrals.count == 5
        #  ifs_result = Infusionsoft.contact_add_to_group(contact[0]["id"], 1218)
        #elsif contact.count > 0 && @referred_by.referrals.count == 10
        #  ifs_result = Infusionsoft.contact_add_to_group(contact[0]["id"], 1220)
        #end

        #puts ifs_result
        #puts '------------'
      end

      #contact_id = Infusionsoft.contact_add_with_dup_check({:FirstName => @user.name, :Email => @user.email}, 'Email');
      #if contact_id
      #  Infusionsoft.contact_add_to_group(contact_id, 1208)
      #  Infusionsoft.email_optin(@user.email, "RAF App Opt-In")
      #end

      @user.delay.add_to_infusionsoft
    end

    # Send them over refer action
    respond_to do |format|
      if !@user.nil?
        cookies[:h_email] = { :value => @user.email }
        unless @user.infusionsoft_affiliate_link.blank?
          format.html { redirect_to @user.infusionsoft_affiliate_link }
        else
          format.html { redirect_to '/thank-you' }
        end
      else
        format.html { redirect_to root_path, :alert => "Something went wrong!" }
      end
    end
  end

  def thankyou
    email = cookies[:h_email]

    @bodyId = 'refer'
    @is_mobile = mobile_device?

    @user = User.find_by_email(email)

    respond_to do |format|
      if !@user.nil?
        format.html
      else
        format.html { redirect_to root_path, :alert => "Something went wrong!" }
      end
    end
  end

  def results
    if params.key?("token")
      token = params[:token].to_s
      uri = URI("http://quiz.ultimate-bundles.com/user_data/?token=#{token}")
	  @results = JSON.parse(Net::HTTP.get(uri))
    end 

    email = cookies[:h_email]

    @bodyId = 'refer'
    @is_mobile = mobile_device?

    @user = User.find_by_email(email)

    respond_to do |format|
      if !@user.nil?
        format.html
      else
        format.html { redirect_to root_path, :alert => "Something went wrong!" }
      end
    end
  end


  def refer
    email = cookies[:h_email]

    @bodyId = 'refer'
    @is_mobile = mobile_device?

    @user = User.find_by_email(email)

    respond_to do |format|
      if !@user.nil?
        format.html
      else
        format.html { redirect_to root_path, :alert => "Something went wrong!" }
      end
    end
  end

  def redirect
    redirect_to root_path, :status => 404
  end

  private

  def user_params
    params.require(:episode).permit(:name, :email, :infusionsoft_affiliate_link)
  end

  def skip_first_page
    if !Rails.application.config.ended
      email = cookies[:h_email]
      if email and !User.find_by_email(email).nil?
        redirect_to '/thank-you'
      else
        cookies.delete :h_email
      end
    end
  end
end
