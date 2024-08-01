class SessionsController < ApplicationController
  before_action :find_user, only: :create

  def create
    if authenticated? && activated?
      handle_successful_login
    else
      handle_failed_login
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end

  private

  def find_user
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
  end

  def authenticated?
    @user&.authenticate(params.dig(:session, :password))
  end

  def activated?
    @user.activated?
  end

  def handle_successful_login
    forwarding_url = session[:forwarding_url]
    reset_session
    remember_me = params.dig(:session, :remember_me)
    remember_me == "1" ? remember(@user) : forget(@user)
    log_in(@user)
    redirect_to forwarding_url || @user
  end

  def handle_failed_login
    flash.now[:danger] = t ".message.invalid_email_password_combination"
    render :new, status: :unprocessable_entity
  end
end
