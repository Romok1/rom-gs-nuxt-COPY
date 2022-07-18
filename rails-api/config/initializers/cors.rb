# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    # @TODO: Restore this configuration once we understand the problem better.
    # origins Rails.application.credentials.dig(:cors, :origins).split(',').map(&:strip)

    resource '/rails/active_storage/direct_uploads',
      headers: :any,
      methods: :put,
      expose: %w[
        Authorization
        Origin
        Content-Type
        Content-MD5
        Content-Disposition
      ],
      max_age: 3600

    resource '/v1/*',
      headers: %w[Authorization Accept Content-Type],
      methods: :any,
      expose: %w[Authorization],
      max_age: 600
  end
end
