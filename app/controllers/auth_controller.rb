# app/controllers/auth_controller.rb
class AuthController < ApplicationController
  skip_before_action :authenticate_user!

  def check_credentials
    email = params[:email]
    password = params[:password]

    Rails.logger.info("email received: #{email}") if email.present?
    Rails.logger.info("password received: #{password}") if password.present?

    if email.present? && password.present?
      user = User.find_by(email: email.downcase)

      if user&.valid_password?(password)
        sign_in(user)

      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    else
      render json: { error: 'Email and password must be provided' }, status: :bad_request
    end
  end
end
