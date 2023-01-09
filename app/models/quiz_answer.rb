class QuizAnswer < ApplicationRecord
  belongs_to :quiz
  belongs_to :user

  has_many :question_answers
end
