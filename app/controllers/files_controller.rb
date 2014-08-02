class FilesController < ActionController::Base
  after_filter :cors_set_access_control_headers

  # For all responses in this controller, return the CORS access control headers.

  def cors_set_access_control_headers
    headers["Access-Control-Allow-Origin"]  = request.env["HTTP_ORIGIN"]
    headers["Access-Control-Allow-Methods"] = "GET"
    headers["Access-Control-Max-Age"]       = "1728000"
  end

  ##
  # Use CDN for load balancing, high availability and performance.
  #
  def serve
    file = Mongoid::GridFS[params[:id]]

    if file
      send_data file.data, type: file.content_type, disposition: "inline"
    else
      head :not_found
    end
  end
end
