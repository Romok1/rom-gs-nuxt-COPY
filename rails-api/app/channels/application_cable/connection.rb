module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user(request['token'])
    end

    private

    def find_verified_user(token)
      secret = Devise::JWT.config.secret
      token_decoded = JWT.decode(token, secret)

      verified_user = User.find_by_jti(token_decoded[0]['jti'])

      verified_user || reject_unauthorized_connection
    rescue StandardError
      reject_unauthorized_connection
    end
  end
end
