class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  
  validates :email, :type, presence: true
         
  def jwt_payload
    { user_type: type }
  end

  def main?
    type == 'Main'
  end

  def subsidiary?
    type == 'Subsidiary'
  end

end
