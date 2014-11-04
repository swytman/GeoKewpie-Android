# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141104162050) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "champs", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "champ_type"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_priority",   default: 0
    t.string   "label_css_schema"
    t.string   "group_key"
    t.integer  "y_cards_limit",    default: 3
  end

  create_table "champs_teams", force: true do |t|
    t.integer "champ_id"
    t.integer "team_id"
  end

  create_table "contracts", force: true do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.date     "join_date"
    t.date     "leave_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number"
    t.integer  "games",      default: 0
    t.integer  "goals",      default: 0
    t.integer  "y_cards",    default: 0
    t.integer  "dbl_cards",  default: 0
    t.integer  "r_cards",    default: 0
    t.integer  "disq_games", default: 0
  end

  create_table "games", force: true do |t|
    t.integer  "home_id"
    t.integer  "visiting_id"
    t.integer  "stage_id"
    t.string   "status",           default: "empty"
    t.date     "date"
    t.integer  "place_id"
    t.integer  "home_scores"
    t.integer  "visiting_scores"
    t.integer  "home_points"
    t.integer  "visiting_points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.time     "time",             default: '2000-01-01 19:00:00'
    t.integer  "tour_id"
    t.integer  "winner_id"
    t.integer  "game_home_id"
    t.integer  "game_visiting_id"
    t.integer  "yellow_cards",                                     array: true
    t.integer  "dbl_yellow_cards",                                 array: true
    t.integer  "red_cards",                                        array: true
    t.integer  "home_players",                                     array: true
    t.integer  "visiting_players",                                 array: true
    t.string   "player_scores",                                    array: true
    t.string   "place"
  end

  create_table "games_players_score", force: true do |t|
    t.integer "game_id"
    t.integer "player_id"
    t.integer "team_id"
    t.integer "score"
    t.integer "yellowcards"
    t.integer "redcards"
    t.integer "assists"
  end

  create_table "games_referees", force: true do |t|
    t.integer "game_id"
    t.integer "referee_id"
  end

  create_table "groups", force: true do |t|
    t.string "key"
    t.string "title"
  end

  create_table "groups_users", id: false, force: true do |t|
    t.integer "user_id",  null: false
    t.integer "group_id", null: false
  end

  create_table "places", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "middlename"
    t.string   "phone"
    t.date     "birthdate"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "text"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "referees", force: true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "middlename"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stages", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "stage_type"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "status"
    t.integer  "champ_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_logos", force: true do |t|
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "title"
    t.string   "desc"
    t.string   "status"
    t.integer  "parent_team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "win",            default: 0
    t.integer  "lose",           default: 0
    t.integer  "draw",           default: 0
    t.integer  "scored",         default: 0
    t.integer  "missed",         default: 0
    t.integer  "points",         default: 0
    t.integer  "champ_id"
    t.integer  "team_logo_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
