class JsonWebToken
  class ExpiredSignature < StandardError; end
  class DecodeError < StandardError; end
  class VerificationError < StandardError; end

  SECRET = Rails.application.secrets.secret_key_base.freeze

  def self.encode(payload, exp = 1.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET)
  end

  def self.decode(token, verify = true)
    body = JWT.decode(token, SECRET, verify)[0]
    HashWithIndifferentAccess.new body
  rescue JWT::ExpiredSignature => e
    raise ExpiredSignature.new(e.message)
  rescue JWT::DecodeError => e
    raise DecodeError.new(e.message)
  rescue JWT::VerificationError => e
    raise VerificationError.new(e.message)
  end
end
