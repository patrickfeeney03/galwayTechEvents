class RegistrationsController < ApplicationController
  # We allow unauthorized access since people don't need to be signed up to be able to Register
  allow_unauthenticated_access

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    # Maybe refactor this to only have a single else? testing
    # still a bit confused about redirect and render.
    if @user.save
      if (user = User.authenticate_by(user_params.permit(:email_address, :password)))
        start_new_session_for user
        session[:user_id] = user.id
        redirect_to after_authentication_url, notice: "Account successfully registered!"
      else
        render :new, status: :unprocessable_entity
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email_address, :password, :password_confirmation, :name, :last_name)
  end
end
