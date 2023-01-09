class CreateQuizzes < ActiveRecord::Migration[6.1]
  def change
    create_table :quizzes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :q_type
      t.string :description
      t.datetime :start_date
      t.datetime :end_date
      t.time :start_time
      t.time :end_time
      t.integer :code

      t.timestamps
    end
  end
end
