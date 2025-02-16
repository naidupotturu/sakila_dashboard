class Api::UsersController < Api::ApplicationController

  before_action :set_user, only: [:update]

  def update
    if @user.update(active: params[:active])
      render json: { message: "User updated successfully", user: @user }, status: :ok
    else
      render json: { error: "Failed to update user" }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: "User not found" }, status: :not_found unless @user
  end
end
