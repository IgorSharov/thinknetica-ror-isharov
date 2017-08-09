# frozen_string_literal: true

class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :title
      t.text :body

      t.timestamps
    end

    create_table :answers do |t|
      t.belongs_to :question, index: true

      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
