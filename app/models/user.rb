class User < ApplicationRecord
  has_many :posting_threads
  has_many :comments
  has_many :likes

  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable,
         :timeoutable, :trackable

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, uniqueness: true
end
