class UsersController < ApplicationController
  before_action :authorized, only: [:check_login]

  # SIGN UP
  def create
    @user = User.new(user_params)
    if @user.save
      token = encode_token({ user_id: @user.id })
      render json: UserBlueprint.render(@user, token: token), status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # SIGN IN
  def login
    if @user = User.authenticate(user_params[:nickname], user_params[:password])
      token = encode_token({ user_id: @user.id })
      render json: UserBlueprint.render(@user, token: token), status: :created
    else
      render json: { errors: 'Invalid credentials' },
      status: :unprocessable_entity
    end
  end

  def check_login
    render json: UserBlueprint.render(@current_user), status: :ok
  end

private

  def user_params
    params.permit(:nickname, :password)
  end
end
