# frozen_string_literal: true

module V1
  class ImportErrorsController < ApplicationController
    before_action :authenticate_v1_user!
    before_action :set_gef_project, only: %i[index]

    def index
      error_json = Mappers::ImportErrors.new(@gef_project).call

      render json: error_json, status: :ok
    end

    private

    def set_gef_project
      @gef_project = authorize GEFProject.find_by_gef_id(params[:gef_project_id])
    end
  end
end
