class Authentication
  class RequiredParamsValidationError < StandardError ; end

  attr_reader :password, :user, :username

  def initialize(user_object)
    @username = user_object[:username]
    @password = user_object[:password]
    @user = User.find_by_username(username)
  end

  def authenticate
    validate_authentication_params
    user
  end

  def generate_token
    JsonWebToken.encode(user_id: user.id)
  end

  def validate_authentication_params
    unless username.present?
      raise RequiredParamsValidationError.new('Username cannot be blank')
    end
    unless password.present?
      raise RequiredParamsValidationError.new('Password cannot be blank')
    end
    unless user && user.authenticate(password).present?
      raise RequiredParamsValidationError.new('User not found for given username and password')
    end
  end
end
