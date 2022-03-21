class ApplicationController < ActionController::API
  SECRET = 'my$ecretK3y'

  # before_action :authorized

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: "Not Found" }, status: :not_found
  end

  rescue_from ActionController::InvalidAuthenticityToken do |e|
    render json: { error: "Invalid token" }, status: :unauthorized
  end

private
  def encode_token(payload)
    JWT.encode(payload, SECRET)
  end

  def auth_header
    request.headers['Authorization'] # { Authorization: 'Bearer <token>' }
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, SECRET, true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def logged_user
    if decoded_token
      @user_id = decoded_token[0]['user_id']
      current_user.present?
    else
      false
    end
  end

  def logged_in?
    !!logged_user
  end

  def authorized
    unless logged_in?
      render json: { error: 'Requires authentication' },
             status: :unauthorized
      return
    end
  end

  def current_user
    @current_user ||= User.find_by(id: @user_id)
  end
end
