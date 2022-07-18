# frozen_string_literal: true

module Mappers
  class RecordFromString
    def call(search_string, klass)
      klass.find_by(name: search_string) || find_record_by_alternative_name(search_string, klass)
    end

    def find_record_by_alternative_name(search_string, klass)
      # Need to account for similar names like 'Republic of The Congo' and 'Democratic Republic of The Congo'
      matching_records = klass.where('name ILIKE ?', "%#{search_string}%").or(
        klass.where('alternative_names ILIKE ?', "%#{search_string}%")
      )

      # if there are no matches or one match we return nil or the match
      if matching_records.count < 2
        matching_records.first
      else
        matching_records.find do |matching_record|
          search_string.downcase.in?(alternative_names_in_downcase(matching_record))
        end
      end
    end

    def alternative_names_in_downcase(matching_record)
      matching_record.alternative_names ? matching_record.alternative_names.split(',').map(&:strip).map(&:downcase) : []
    end
  end
end
