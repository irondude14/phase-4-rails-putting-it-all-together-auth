class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    if user.valid?
      session[:user_id] = user.id
      render json: user, status: :created
    else
      render json: {
               errors: user.errors.full_messages,
             },
             status: :unprocessable_entity
    end
  end

  def show
    if session[:user_id]
      current_user = User.find(session[:user_id])
      render json: current_user
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(
      :username,
      :password,
      :password_confirmation,
      :image_url,
      :bio,
    )
  end
end
