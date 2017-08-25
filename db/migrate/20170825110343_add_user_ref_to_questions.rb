# frozen_string_literal: true

class AddUserRefToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_reference :questions, :user, foreign_key: true
    change_column_null :questions, :user_id, false
  end
end
