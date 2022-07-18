# frozen_string_literal: true

module V1
  class LastSyncController < ApplicationController
    before_action :authenticate_v1_user!

    def show
      render json: GEFProjectImport.last_sync.as_json(only: %i[updated_at status]), status: :ok
    end
  end
end
