class Api::UsersController < ApplicationController
  def index
    users = User.all
    render json: users
  end

  def update
    user = User.find(params[:id])
    user.update(active: params[:active], updated_at: Time.current)
    render json: user
  end
end
