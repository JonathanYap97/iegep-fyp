class Quiz < ApplicationRecord
  belongs_to :user

  has_many :questions
  has_many :quiz_answers
end
