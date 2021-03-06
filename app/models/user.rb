class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validates :username, presence: :true, uniqueness: :true
  # validates :preferred_language, presence: :true
  has_many :bookshelves, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one :profile, dependent: :destroy
  before_create :create_profile

  def create_profile
    profile = build_profile(first_name: "", last_name: "", about: "")
  end

end
