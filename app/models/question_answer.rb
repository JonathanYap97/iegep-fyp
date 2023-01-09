class QuestionAnswer < ApplicationRecord
  belongs_to :question
  belongs_to :quiz_answer
end
