# frozen_string_literal: true

class AddUserRefToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_reference :answers, :user, foreign_key: true
    change_column_null :answers, :user_id, false
  end
end
