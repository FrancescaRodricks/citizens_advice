class AuthTokenValidator
  class ExpiredTokenError < StandardError ; end
  class RequiredParamsValidationError < StandardError ; end

  attr_reader :token
  attr_accessor :user_id, :decoded_token

  TOKEN_EXPIRY_MIN_MINUTES = (60 * 60) * 2

  def initialize(params)
    @token = params[:token]
  end

  def valid_token?
    validate_params
    user_id = JsonWebToken.decode(token)['user_id']
    self.user_id = user_id
    return true if user_id
  rescue JsonWebToken::ExpiredSignature
    self.decoded_token = JsonWebToken.decode(token, false)
    self.user_id = decoded_token['user_id']
    return true
  end

  def refresh_token
    user = User.find_by_id(user_id)
    if decoded_token
      time_to_expire_token = decoded_token['exp']
      if (Time.now.to_i - time_to_expire_token ) <= TOKEN_EXPIRY_MIN_MINUTES
        JsonWebToken.encode(user_id: user.id)
      else
        raise ExpiredTokenError.new("Token cannot be refreshed. Minimum time to refresh token has passed")
      end
    else
      JsonWebToken.encode(user_id: user.id)
    end
  end

  private
  def validate_params
    unless token.present?
      raise RequiredParamsValidationError.new('Token cannot be blank')
    end
  end
end
