class Authorization
  def initialize(request)
    @token = request.headers[:HTTP_TOKEN]
  end

  def current_user
    decoded_token = JsonWebToken.decode(@token) if @token
    user_id = decoded_token['user_id'] if decoded_token
    User.find_by_id(user_id)
  end
end
