# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_07_07_115437) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "focal_areas", force: :cascade do |t|
    t.string "name", null: false
    t.string "alternative_names"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tag"
    t.index ["alternative_names"], name: "index_focal_areas_on_alternative_names"
    t.index ["name"], name: "index_focal_areas_on_name"
    t.index ["tag"], name: "index_focal_areas_on_tag", unique: true
  end

  create_table "focal_areas_gef_projects", force: :cascade do |t|
    t.bigint "gef_project_id"
    t.bigint "focal_area_id"
    t.index ["focal_area_id"], name: "index_focal_areas_gef_projects_on_focal_area_id"
    t.index ["gef_project_id"], name: "index_focal_areas_gef_projects_on_gef_project_id"
  end

  create_table "gef_project_import_errors", force: :cascade do |t|
    t.bigint "gef_project_import_id"
    t.bigint "gef_project_id"
    t.integer "row_number", default: 0, null: false
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gef_project_id"], name: "index_gef_project_import_errors_on_gef_project_id"
    t.index ["gef_project_import_id"], name: "index_gef_project_import_errors_on_gef_project_import_id"
  end

  create_table "gef_project_imports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
  end

  create_table "gef_projects", force: :cascade do |t|
    t.string "gef_id", null: false
    t.text "title", null: false
    t.string "short_title"
    t.string "current_status"
    t.string "project_grant"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mid_term_evaluation_status"
    t.string "terminal_evaluation_status"
    t.datetime "discarded_at"
    t.index ["current_status"], name: "index_gef_projects_on_current_status"
    t.index ["discarded_at"], name: "index_gef_projects_on_discarded_at"
    t.index ["gef_id"], name: "index_gef_projects_on_gef_id"
    t.index ["project_grant"], name: "index_gef_projects_on_project_grant"
    t.index ["short_title"], name: "index_gef_projects_on_short_title"
    t.index ["title"], name: "index_gef_projects_on_title"
  end

  create_table "gef_projects_georegions", force: :cascade do |t|
    t.bigint "gef_project_id"
    t.bigint "georegion_id"
    t.index ["gef_project_id"], name: "index_gef_projects_georegions_on_gef_project_id"
    t.index ["georegion_id"], name: "index_gef_projects_georegions_on_georegion_id"
  end

  create_table "gef_projects_implementing_agencies", force: :cascade do |t|
    t.bigint "gef_project_id"
    t.bigint "implementing_agency_id"
    t.index ["gef_project_id"], name: "gef_projects_implementing_agencies_index"
    t.index ["implementing_agency_id"], name: "implementing_agencies_gef_projects_index"
  end

  create_table "gef_projects_timeline_events", force: :cascade do |t|
    t.date "date", null: false
    t.bigint "timeline_event_id"
    t.bigint "gef_project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_gef_projects_timeline_events_on_date"
    t.index ["gef_project_id"], name: "index_gef_projects_timeline_events_on_gef_project_id"
    t.index ["timeline_event_id"], name: "index_gef_projects_timeline_events_on_timeline_event_id"
  end

  create_table "gef_projects_users", force: :cascade do |t|
    t.bigint "gef_project_id"
    t.bigint "user_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gef_project_id"], name: "index_gef_projects_users_on_gef_project_id"
    t.index ["role_id"], name: "index_gef_projects_users_on_role_id"
    t.index ["user_id"], name: "index_gef_projects_users_on_user_id"
  end

  create_table "georegion_types", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_georegion_types_on_name"
  end

  create_table "georegions", force: :cascade do |t|
    t.string "name", null: false
    t.string "iso"
    t.string "m49"
    t.bigint "georegion_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "alternative_names"
    t.index ["georegion_type_id"], name: "index_georegions_on_georegion_type_id"
    t.index ["iso"], name: "index_georegions_on_iso"
    t.index ["m49"], name: "index_georegions_on_m49"
    t.index ["name"], name: "index_georegions_on_name"
  end

  create_table "implementing_agencies", force: :cascade do |t|
    t.string "name", null: false
    t.string "alternative_names"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alternative_names"], name: "index_implementing_agencies_on_alternative_names"
    t.index ["name"], name: "index_implementing_agencies_on_name"
  end

  create_table "indicator_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "indicator_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "indicator_desc_idx"
  end

  create_table "indicator_import_errors", force: :cascade do |t|
    t.bigint "indicator_import_id"
    t.bigint "gef_project_id"
    t.integer "row_number", default: 0, null: false
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gef_project_id"], name: "index_indicator_import_errors_on_gef_project_id"
    t.index ["indicator_import_id"], name: "index_indicator_import_errors_on_indicator_import_id"
  end

  create_table "indicator_imports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
  end

  create_table "indicator_scores", force: :cascade do |t|
    t.float "value"
    t.bigint "gef_project_id"
    t.bigint "indicator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year"
    t.integer "assessment_type"
    t.index ["assessment_type"], name: "index_indicator_scores_on_assessment_type"
    t.index ["gef_project_id"], name: "index_indicator_scores_on_gef_project_id"
    t.index ["indicator_id"], name: "index_indicator_scores_on_indicator_id"
    t.index ["value"], name: "index_indicator_scores_on_value"
    t.index ["year"], name: "index_indicator_scores_on_year"
  end

  create_table "indicator_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "indicators", force: :cascade do |t|
    t.text "name", null: false
    t.bigint "indicator_type_id"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tag"
    t.index ["indicator_type_id"], name: "index_indicators_on_indicator_type_id"
    t.index ["name"], name: "index_indicators_on_name"
    t.index ["parent_id"], name: "index_indicators_on_parent_id"
    t.index ["tag"], name: "index_indicators_on_tag", unique: true
  end

  create_table "layerable_spatial_datasets", force: :cascade do |t|
    t.string "layerable_type"
    t.bigint "layerable_id"
    t.bigint "spatial_dataset_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["layerable_type", "layerable_id"], name: "index_layerable_spatial_datasets_on_layerable"
    t.index ["spatial_dataset_id"], name: "index_layerable_spatial_datasets_on_spatial_dataset_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name"
    t.index ["name"], name: "role_name_is_unique", unique: true
  end

  create_table "shapefile_import_errors", force: :cascade do |t|
    t.bigint "shapefile_id"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shapefile_id"], name: "index_shapefile_import_errors_on_shapefile_id"
  end

  create_table "shapefiles", force: :cascade do |t|
    t.bigint "gef_project_id"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gef_project_id"], name: "index_shapefiles_on_gef_project_id"
  end

  create_table "spatial_dataset_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spatial_dataset_urls", force: :cascade do |t|
    t.string "url", null: false
    t.date "date"
    t.bigint "spatial_dataset_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "spatial_dataset_id"], name: "index_spatial_dataset_urls_on_date_and_spatial_dataset_id", unique: true
    t.index ["spatial_dataset_id"], name: "index_spatial_dataset_urls_on_spatial_dataset_id"
  end

  create_table "spatial_datasets", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.string "spatial_dataset_type_type"
    t.bigint "spatial_dataset_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spatial_dataset_type_type", "spatial_dataset_type_id"], name: "index_spatial_datasets_on_spatial_dataset_type"
  end

  create_table "timeline_events", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order"
    t.index ["name"], name: "index_timeline_events_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.bigint "role_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "focal_areas_gef_projects", "focal_areas"
  add_foreign_key "focal_areas_gef_projects", "gef_projects"
  add_foreign_key "gef_project_import_errors", "gef_project_imports"
  add_foreign_key "gef_project_import_errors", "gef_projects"
  add_foreign_key "gef_projects_georegions", "gef_projects"
  add_foreign_key "gef_projects_georegions", "georegions"
  add_foreign_key "gef_projects_implementing_agencies", "gef_projects"
  add_foreign_key "gef_projects_implementing_agencies", "implementing_agencies"
  add_foreign_key "gef_projects_timeline_events", "gef_projects"
  add_foreign_key "gef_projects_timeline_events", "timeline_events"
  add_foreign_key "gef_projects_users", "gef_projects"
  add_foreign_key "gef_projects_users", "roles"
  add_foreign_key "gef_projects_users", "users"
  add_foreign_key "georegions", "georegion_types"
  add_foreign_key "indicator_import_errors", "gef_projects"
  add_foreign_key "indicator_import_errors", "indicator_imports"
  add_foreign_key "indicator_scores", "gef_projects"
  add_foreign_key "indicator_scores", "indicators"
  add_foreign_key "indicators", "indicator_types"
  add_foreign_key "layerable_spatial_datasets", "spatial_datasets"
  add_foreign_key "shapefile_import_errors", "shapefiles"
  add_foreign_key "shapefiles", "gef_projects"
  add_foreign_key "spatial_dataset_urls", "spatial_datasets"
end
