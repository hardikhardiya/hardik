class ApplicationController < ActionController::Base
  before_filter :set_i18n_locale_from_params
  protect_from_forgery
  before_filter :authorize


 protected
  def set_i18n_locale_from_params
   if params[:locale]
     if I18n.available_locales.include?(params[:locale].to_sym)
       I18n.locale = params[:locale]
     else
      flash.now[:notice] = " #{params[:locale]} translation not available"
      logger.error flash.now[:notice]
     end
   end
  end 
   def default_url_options
    { :locale => I18n.locale }
   end



  # private
  # def current_cart
  #  Cart.find(session[:card_id])
  # rescue ActiveRecord::RecordNotFound
  #  cart = Cart.create
  #  session[:cart_id] = cart.id
  #  cart 
  # end


 private
    def current_cart
      @cart = Cart.where(id: session[:cart_id]).first #this will return nil if the Cart with id session[:cart_id] does not exist
      @cart = Cart.create if @cart.nil?
      session[:cart_id] = @cart.id
      @cart
    end

 protected
    
    def authorize
       unless User.find_by_id(session[:user_id])
          redirect_to login_url, :notice => "Please log in"
        end 
    end   



end
