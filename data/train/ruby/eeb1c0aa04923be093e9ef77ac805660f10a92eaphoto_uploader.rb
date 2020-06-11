class PhotoUploader < BasicImageUploader
  version :full_screen do
    process resize_to_fit: [1920, 1080]
    process watermarking: [BasicImageUploader.watermark_logo, :south]
    process quality: 75
  end

  version :medium do
    process resize_to_fill: [768, 432]
    process watermarking: [BasicImageUploader.watermark_logo, :south]
    process quality: 75
  end

  version :small do
    process resize_to_fill: [485, 273]
    process quality: 70
  end

  version :thumb do
    process resize_to_fill: [80, 40]
    process quality: 70
  end
end

