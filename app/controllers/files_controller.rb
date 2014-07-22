class FilesController < ActionController::Base
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
