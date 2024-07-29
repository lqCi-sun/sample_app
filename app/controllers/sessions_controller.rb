class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user.authenticate params.dig(:session, :password)
      reset_session
      log_in @user
      redirect_to @user, status: :see_other
    else
      flash.now[:danger] = t ".message.invalid_email_password_combination"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end

  private

  def load_user
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
    return if @user

    flash.now[:danger] = t ".message.invalid_email_password_combination"
    render :new, status: :unprocessable_entity
  end
end
