class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :title, presence: true
  validates :name,  presence: true
  validates :content, presence: true, length: {minimum: 5}

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "name", "old", "title", "updated_at"]
  end
  
end
