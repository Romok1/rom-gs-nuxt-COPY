module V1
  class GEFProjectsController < ApplicationController
    before_action :authenticate_v1_user!
    before_action :set_gef_project, only: %i[show destroy update]

    # GET /gef_projects
    def index
      if params.key?(:discarded)
        authorize(GEFProject, :discarded?)
        @gef_projects = policy_scope(GEFProject).discarded
      else
        authorize(GEFProject)
        @gef_projects = policy_scope(GEFProject).undiscarded
      end

      render json: @gef_projects.eager_load(
        :shapefile,
        :georegions,
        :gef_project_import_errors,
        :indicator_import_errors,
        :shapefile_import_errors
      ).as_json(
        include: %i[georegions shapefile],
        methods: :has_import_errors
      )
    end

    # GET /gef_projects/1
    def show
      render json: @gef_project.as_json(
        include: %i[georegions implementing_agencies focal_areas],
        methods: %i[task_manager fmo pa_focal_point fa_focal_point timeline]
      )
    end

    # DELETE /gef_projects/1
    def destroy
      if @gef_project.discard
        render json: {}, status: :ok
      else
        render json: @gef_project.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /gef_projects/1
    def update
      # At the moment this should only handle soft-deletes (archiving).
      # All other project state should mirror the spreadsheet
      if @gef_project.undiscard
        render json: @gef_project, status: :ok
      else
        render json: { message: @gef_project.errors }, status: :unprocessable_entity
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_gef_project
      authorize @gef_project = GEFProject.find_by_gef_id(params[:id])
    end
  end
end
