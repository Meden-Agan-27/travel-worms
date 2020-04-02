class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validates :username, presence: :true, uniqueness: :true
  # validates :preferred_language, presence: :true
  has_many :bookshelves, dependent: :destroy
  has_many :reviews, dependent: :destroy

  has_many :friendships_as_asker, source: :friendships, foreign_key: :asker_id
  has_many :friendships_as_receiver, source: :friendships, foreign_key: :receiver_id

  has_one :profile, dependent: :destroy
  before_create :create_profile

  def create_profile
    profile = build_profile(first_name: "", last_name: "", about: "")
  end

  def friends
    @friends = Friendship.where()
  end

end
