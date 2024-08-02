class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.sorted, limit: Settings.page_10
  end

  def show
    @pagy, @microposts = pagy @user.microposts, limit: Settings.page_10
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".message.check_mail"
      redirect_to root_url, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".message.profile_updated"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".message.user_deleted"
    else
      flash[:danger] = t ".message.delete_fail"
    end
    redirect_to users_path
  end

  def following
    @title = t ".following"
    @pagy, @users = pagy @user.following, limit: Settings.page_10
    render :show_follow
  end

  def followers
    @title = t ".followers"
    @pagy, @users = pagy @user.followers, limit: Settings.page_10
    render :show_follow
  end

  private

  def admin_user
    return if current_user.admin?

    flash[:danger] = t ".message.not_authorized"
    redirect_to root_path
  end

  def find_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t ".message.not_found"
    redirect_to root_url
  end

  def correct_user
    return if current_user?(@user)

    flash[:error] = t ".message.cannot_edit"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit(User::USER_PARAMS)
  end
end
