# frozen_string_literal: true

class FileUploader < CarrierWave::Uploader::Base
  delegate :filename, to: :file

  storage :file

  def store_dir
    return store_dir_for_test if Rails.env.test?
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def store_dir_for_test
    "#{Rails.root}/spec/support/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
