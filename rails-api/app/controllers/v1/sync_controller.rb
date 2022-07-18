# frozen_string_literal: true

module V1
  class SyncController < ApplicationController
    before_action :authenticate_v1_user!

    def create
      if SyncStatus.new.should_sync_again?
        ImportJob.perform_later
        render json: {}, status: :ok
      else
        render json: I18n.t('imports.queuing.already_in_progress'), status: :unprocessable_entity
      end
    end
  end
end
