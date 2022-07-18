# frozen_string_literal: true

require Rails.root.join('lib/core_extensions/active_record/autosave_association.rb')

ActiveSupport.on_load(:active_record) do
  include CoreExtensions::ActiveRecord::AutosaveAssociation
end
