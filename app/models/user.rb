class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :tweets

  #Sets up the connection for us to upload
  mount_uploader :avatar, AvatarUploader

  #A Validation allows us to make sure that whatever data is entered is exactly how we want it to be entered 
  validates :username, presence: true, uniqueness: true

  #Serialize is a method that we use to trick the attribute following that has the datatype text to act like an array. 
  #We do this so we can put in and take out our followings by putting the user_id
      serialize :following, Array

end
