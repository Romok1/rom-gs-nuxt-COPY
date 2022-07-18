# frozen_string_literal: true

georegion_types = YAML.load_file(Rails.root.join('db/data/georegion_types.yml'))
GeoregionType.create!(georegion_types.map(&:deep_symbolize_keys))

country_georegion_type_id = GeoregionType.find_by(name: 'country').id
region_georegion_type_id = GeoregionType.find_by(name: 'region').id

countries = YAML.load_file(Rails.root.join('db/data/countries.yml'))
countries_attributes = countries.map(&:deep_symbolize_keys)
countries_attributes.map { |country| country[:georegion_type_id] = country_georegion_type_id }

regions = YAML.load_file(Rails.root.join('db/data/regions.yml'))
regions_attributes = regions.map(&:deep_symbolize_keys)
regions_attributes.map { |region| region[:georegion_type_id] = region_georegion_type_id }

Georegion.create!(regions_attributes + countries_attributes)
