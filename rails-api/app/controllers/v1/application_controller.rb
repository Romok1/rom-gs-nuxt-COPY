# frozen_string_literal: true

module V1
  class ApplicationController < ActionController::API
    # @see https://stackoverflow.com/a/35985101/1090438
    include ActionController::MimeResponds
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    before_action :underscore_params!

    respond_to :json

    private

    def pundit_user
      current_v1_user
    end

    def underscore_params!
      params.deep_transform_keys!(&:underscore)
    end

    def user_not_authorized
      render json: { message: I18n.t('errors.http.forbidden') }, status: :forbidden
    end
  end
end
