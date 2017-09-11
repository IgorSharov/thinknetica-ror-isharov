# frozen_string_literal: true

class AddBestAnswerMarkToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :best_answer, :boolean
  end
end
