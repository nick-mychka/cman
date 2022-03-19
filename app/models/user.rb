class User < ApplicationRecord
  has_secure_password

  has_many :clusters, dependent: :destroy

  validates :nickname, presence: true, uniqueness: { case_sensitive: false }

  def self.authenticate(nickname, password)
    user = User.find_by(nickname: nickname)
    user && user.authenticate(password)
  end
end
