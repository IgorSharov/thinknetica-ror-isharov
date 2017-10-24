# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171024164714) do
  create_table 'answers', force: :cascade do |t|
    t.integer 'question_id', null: false
    t.text 'body', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'user_id', null: false
    t.boolean 'best_answer'
    t.index ['question_id'], name: 'index_answers_on_question_id'
    t.index ['user_id'], name: 'index_answers_on_user_id'
  end

  create_table 'attachments', force: :cascade do |t|
    t.string 'file'
    t.string 'attachable_type'
    t.integer 'attachable_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[attachable_type attachable_id], name: 'index_attachments_on_attachable_type_and_attachable_id'
  end

  create_table 'auth_accounts', force: :cascade do |t|
    t.integer 'user_id'
    t.string 'provider', null: false
    t.string 'uid', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[provider uid], name: 'index_auth_accounts_on_provider_and_uid'
    t.index ['user_id'], name: 'index_auth_accounts_on_user_id'
  end

  create_table 'comments', force: :cascade do |t|
    t.string 'commentable_type'
    t.integer 'commentable_id'
    t.integer 'user_id'
    t.text 'body', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[commentable_type commentable_id], name: 'index_comments_on_commentable_type_and_commentable_id'
    t.index ['user_id'], name: 'index_comments_on_user_id'
  end

  create_table 'questions', force: :cascade do |t|
    t.string 'title', null: false
    t.text 'body', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'user_id', null: false
    t.index ['user_id'], name: 'index_questions_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string 'current_sign_in_ip'
    t.string 'last_sign_in_ip'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.index ['confirmation_token'], name: 'index_users_on_confirmation_token', unique: true
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  create_table 'votes', force: :cascade do |t|
    t.string 'votable_type'
    t.integer 'votable_id'
    t.integer 'user_id'
    t.integer 'value', null: false
    t.integer 'vote_type', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_votes_on_user_id'
    t.index %w[votable_type votable_id], name: 'index_votes_on_votable_type_and_votable_id'
  end
end
