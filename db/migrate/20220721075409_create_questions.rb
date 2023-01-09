class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.references :quiz, null: false, foreign_key: true
      t.string :q_text
      t.string :q_type
      t.integer :marks
      t.string :answer_1, null: true
      t.string :answer_2, null: true
      t.string :answer_3, null: true
      t.string :answer_4, null: true
      t.integer :correct_answer

      t.timestamps
    end
  end
end
