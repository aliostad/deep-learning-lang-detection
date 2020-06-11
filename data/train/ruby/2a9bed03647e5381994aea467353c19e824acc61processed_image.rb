# -*- encoding : utf-8 -*-
#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class ProcessedImage < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    if model.target.present?
      "uploads/images/#{model.target.class.name}"
    else
      "uploads/images"
    end
  end

  #def extension_white_list
  #  %w(jpg jpeg png gif tiff)
  #end


  def filename
    @filename if @filename
  end

  version :thumb_small do
    process :pre
    process :resize_to_fill => [50, 50]
    process :strip
  end

  version :thumb_medium do
    process :pre
    process :resize_to_fill => [220, 220]
    process :strip
  end

  version :thumb_large do
    process :pre
    process :resize_to_fill => [350, 350]
    process :strip
  end

  version :thumb_150 do
    process :pre
    process :resize_to_fill => [150, 150]
    process :strip
  end


  #version :normal_small do
  #  process :pre
  #  process :resize_to_fill => [150,200]
  #  process :strip 
  #end

  #version :normal_medium do
  #  process :pre
  #  process :resize_to_fill => [300,400]
  #  process :strip
  #end

  #version :wide_small do
  #  process :pre
  #  process :enhance
  #  process :resize_to_fill => [312, 150]
  #  process :strip
  #end

  #version :wide_medium do
  #  process :pre
  #  process :enhance
  #  process :resize_to_fill => [484,180]
  #  process :strip
  #end

  #version :wide_half do
  #  process :pre
  #  process :enhance
  #  process :resize_to_fill => [242,180]
  #
  #  process :strip
  #end

  #version :wide_large do
  #  process :pre
  #  process :enhance
  #  process :resize_to_fill => [645,240]
  #  process :strip
  #end

  #version :wide_banner do
  #  process :pre
  #  process :enhance
  #  process :resize_to_fill => [710,270]
  #  process :strip
  #end

  #version :scaled_full do
  #  process :pre
  #  process :resize_to_limit => [600,600]
  #  process :strip
  #end

  def pre
    `jhead -autorot #{file.path}`
    #`export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib && enhance #{file.path} #{file.path}`
  end

  def enhance
    #`export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib && enhance #{file.path} #{file.path}`  
  end

  def strip
    manipulate! do |img|
      img.strip
      img = yield(img) if block_given?
      img
    end
  end

end
