class Api::V1::UsersController < ApplicationController
  def register
    @user = User.create(registration_params)
     if @user.save
      response = { message: 'User created successfully', user: { username: @user.username, email: @user.email } }
      render json: response, status: :created
     else
      render json: @user.errors, status: :bad_request
     end
  end

  def login
    authentication_object = Authentication.new(login_params)
    if authentication_object.authenticate
      render json: {
        message: "Token generated successfully",
        token: authentication_object.generate_token
      }, status: :ok
    end
  rescue => error
    render json: {
        message: error.message
      }, status: :unauthorized
  end

  def refresh_token
    auth_token_validator = AuthTokenValidator.new(refresh_token_param)
    if auth_token_validator.valid_token?
      render json: {
        message: "Token refreshed successfully",
        token: auth_token_validator.refresh_token
      }, status: :ok
    end
  rescue => error
    render json: {
        message: error.message
      }, status: :unauthorized
  end

  private

  def registration_params
    params.permit(
      :username,
      :email,
      :password
    )
  end

  def login_params
    params.permit(
      :username,
      :password
    )
  end

  def refresh_token_param
    params.permit(
      :token
    )
  end
end
