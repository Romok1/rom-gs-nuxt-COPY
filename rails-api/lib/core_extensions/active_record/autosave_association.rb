# frozen_string_literal: true

# @see https://github.com/rails/rails/issues/24390#issuecomment-703708842
module CoreExtensions
  module ActiveRecord
    module AutosaveAssociation
      def validate_collection_association(reflection)
        association = association_instance_get(reflection.name)
        return unless association

        records = associated_records_to_validate_or_save(association, new_record?, reflection.options[:autosave])
        return unless records

        all_records = association.target.find_all
        records.each do |record|
          index = all_records.find_index(record)
          association_valid?(reflection, record, index)
        end
      end
    end
  end
end
