module V1
  class SpatialDatasetsController < ApplicationController
    before_action :authenticate_v1_user!

    before_action :set_layerable, only: %i[index]

    def index
      render json: spatial_datasets_as_json
    end

    private

    def spatial_datasets_as_json
      @layerable.spatial_datasets
        .eager_load(:spatial_dataset_urls)
        .as_json(
          only: %i[name description],
          include: {
            spatial_dataset_urls: {
              only: %i[url date]
            },
            spatial_dataset_type: {
              only: [:name]
            }
          }
        )
    end

    def set_layerable
      @layerable = if params[:indicator_id]
                     Indicator.find(params[:indicator_id])
                   else
                     FocalArea.find(params[:focal_area_id])
                   end
    end
  end
end
