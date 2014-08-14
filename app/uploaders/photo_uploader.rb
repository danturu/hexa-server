class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :grid_fs

  def store_dir
    "uploads/#{model.class.to_s.underscore.pluralize}/#{model.id}/#{mounted_as.to_s.pluralize}/"
  end

  version :square do
    process convert: "jpg", resize_to_fill: [150, 150]

    def full_filename(for_file)
      "square.jpg"
    end
  end
end
