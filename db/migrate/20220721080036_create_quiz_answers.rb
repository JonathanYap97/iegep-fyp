class CreateQuizAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :quiz_answers do |t|
      t.references :quiz, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :total_marks, null: true
      t.datetime :start_date
      t.datetime :end_date
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
