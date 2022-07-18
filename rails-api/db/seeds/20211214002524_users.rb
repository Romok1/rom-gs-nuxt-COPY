# frozen_string_literal: true

random_string = rand(36**128).to_s(36)

User.create!(
  name: 'System',
  email: 'noreply@unep-wcmc.org',
  password: random_string,
  role: Role.first
)

return if Rails.env.production?

users = YAML.load_file(Rails.root.join('db/data/users.yml'))

user_params = users.map(&:deep_symbolize_keys)

user_params.map do |user|
  role = Role.find_by_name(user[:role])
  user[:role] = role
end

User.create!(user_params)
