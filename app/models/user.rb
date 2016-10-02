class User < ActiveRecord::Base
  has_many :friend_requests, dependent: :destroy
  has_many :pending_friends, through: :friend_requests, source: :friend
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_and_belongs_to_many :users
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def remove_friend(friend)
    current_user.friends.destroy(friend)
  end

  def self.search(search)
      where("lower(name) LIKE ?", "%#{search.downcase}%")
  end
end
