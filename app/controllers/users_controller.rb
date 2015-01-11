class UsersController < ApplicationController
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

        # remove this later
        #@referred_by = User.find_by_referral_code(cookies[:h_ref])
        #if @referred_by
        #  redirection_url = @referred_by.infusionsoft_affiliate_link
        #else
        #  redirection_url = "http://ultimate-bundles.com/healthy-living-bundle-2014/"
        #end

        #redirect_to redirection_url
        # end of remove this later

        @user = User.new

        @ip_limit = false

        if params.has_key?(:ip_limit)
          @ip_limit = true
        end

        respond_to do |format|
          format.html # new.html.erb
        end
    end

    def create
      unless params.has_key?(:user) && params[:user][:email] && params[:user][:name]
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

          case @referred_by.referrals.count
          when 1
            contact_id = Infusionsoft.contact_find_by_email(@referred_by.email, ['id']);
            if contact_id
              Infusionsoft.contact_add_to_group(contact_id, 1216)
            end
          when 5
            contact_id = Infusionsoft.contact_find_by_email(@referred_by.email, ['id']);
            if contact_id
              Infusionsoft.contact_add_to_group(contact_id, 1218)
            end
          when 10
            contact_id = Infusionsoft.contact_find_by_email(@referred_by.email, ['id']);
            if contact_id
              Infusionsoft.contact_add_to_group(contact_id, 1220)
            end
          end
        end

        @user.name = @user.name.titleize
        @user.save

        contact_id = Infusionsoft.contact_add_with_dup_check({:FirstName => @user.name, :Email => @user.email}, 'Email');
        if contact_id
          Infusionsoft.contact_add_to_group(contact_id, 1208)
        end

      end

      # Send them over refer action
      respond_to do |format|
        if !@user.nil?
          cookies[:h_email] = { :value => @user.email }
          #format.html { redirect_to '/refer-a-friend' }
          unless @user.infusionsoft_affiliate_link.blank?
            format.html { redirect_to @user.infusionsoft_affiliate_link }
          else
            format.html { redirect_to '/refer-a-friend' }
          end
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

    def policy

    end

    def redirect
        redirect_to root_path, :status => 404
    end

    private

    def skip_first_page
        if !Rails.application.config.ended
            email = cookies[:h_email]
            if email and !User.find_by_email(email).nil?
                redirect_to '/refer-a-friend'
            else
                cookies.delete :h_email
            end
        end
    end

end
