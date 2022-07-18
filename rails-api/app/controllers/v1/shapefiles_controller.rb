module V1
  class ShapefilesController < ApplicationController
    before_action :authenticate_v1_user!
    before_action :set_shapefile, only: %i[show update destroy]

    # PUT /gef_projects/1/shapefile
    def update
      if @shapefile.update(shapefile_params)
        # @TODO: delete shapefile from Geoserver once there's a Geoserver end-point
        ShapefileUploadJob.perform_later(@shapefile.id)
        render json: @shapefile, status: :ok
      else
        render json: @shapefile.errors, status: :unprocessable_entity
      end
    end

    # DELETE /gef_projects/1/shapefile
    def destroy
      if @shapefile.destroy
        # @TODO: delete shapefile from Geoserver once there's a Geoserver end-point
        render json: @shapefile, status: :ok
      else
        render json: @shapefile.errors, status: :unprocessable_entity
      end
    end

    # GET /gef_projects/1/shapefile
    def show
      render json: @shapefile.as_json(include: :files)
    end

    private

    def gef_project
      @gef_project = GEFProject.find_by_gef_id(params[:gef_project_id])
    end

    def set_shapefile
      authorize @shapefile = (gef_project.shapefile || Shapefile.create(gef_project:))
    end

    def shapefile_params
      params.require(:shapefile).permit(
        files: []
      )
    end
  end
end
