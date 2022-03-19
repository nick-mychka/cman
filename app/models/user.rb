class User < ApplicationRecord
  has_secure_password

  validates :nickname, presence: true, uniqueness: { case_sensitive: false }

  def self.authenticate(nickname, password)
    user = User.find_by(nickname: nickname)
    user && user.authenticate(password)
  end
end
