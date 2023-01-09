class ChangeQuizUserNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :quizzes, :user_id, true
  end
end
