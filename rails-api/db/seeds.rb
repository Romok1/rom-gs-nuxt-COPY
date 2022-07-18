# frozen_string_literal: true

Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
  basename = File.basename(seed, '.rb')
  puts "== #{basename} seeding"

  load(seed)

  puts "== #{basename} seeded!"
end
