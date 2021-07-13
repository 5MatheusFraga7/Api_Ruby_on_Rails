class Task < ApplicationRecord
  belongs_to :user

  #validates presences
  validates :title, :user_id, presence: true 
end
