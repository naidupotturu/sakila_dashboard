class UsersController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:update]
  def index
    @active_users = User.where(active: true).order(updated_at: :desc)
    @inactive_users = User.where(active: false).order(updated_at: :desc)
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: { status: 'success', user: @user }  # Return JSON response
    else
      render json: { status: 'error', errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:active)  # Ensure the :active parameter is permitted
  end
end
