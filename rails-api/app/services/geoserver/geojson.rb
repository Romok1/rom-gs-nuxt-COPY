module Geoserver
  class Geojson
    def initialize(gef_ids, geometry_type = :point)
      @gef_ids = gef_ids
      @geometry_type = geometry_type
    end

    def call
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      response = https.request(request)
      JSON.parse(response.read_body)
    end

    private

    def request
      @request ||= begin
        authentication = credentials[:basic_auth]
        raise ArgumentError, 'Missing geoserver.basic_auth credentials' unless authentication

        user = authentication[:user]
        password = authentication[:password]

        request = Net::HTTP::Get.new(uri)
        request.basic_auth(user, password)
        request
      end
    end

    def credentials
      @credentials ||= Rails.application.credentials[:geoserver]
    end

    def uri
      @uri ||= begin
        remote_host = credentials[:remote_host]
        ows_endpoint = credentials[:ows_endpoint]
        uri = URI("https://#{remote_host}/#{ows_endpoint}")
        uri.query = URI.encode_www_form(params)
        uri
      end
    end

    def params
      {
        'service' => 'WFS',
        'version' => '2.0.0',
        'request' => 'GetFeature',
        'typeName' => geometry_type,
        'outputFormat' => 'application/json',
        'cql_filter' => "project_id IN(#{@gef_ids.join(',')})"
      }
    end

    def geometry_type
      case @geometry_type.to_sym
      when :polygon
        'grip:project_geoms'
      when :point
        'grip:project_centroids'
      end
    end
  end
end
