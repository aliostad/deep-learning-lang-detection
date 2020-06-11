#!/usr/bin/env ruby
require 'yaml'
require 'fileutils'

dataroot = 'srcdata/'
data = YAML.load_file('srcdata/maps/school/f1.yml')
data['chunks'].each do |chunk_head|
  chunk_id = chunk_head['uri']
  position = chunk_head['position']
  chunk = YAML.load_file(dataroot + chunk_id + '.yml')
  new_data = {
    'id' => chunk['uri'].gsub('chunks', 'maps'),
    'name' => chunk['name'],
    'nodes' => [],
    'zones' => {
      'xsize' => chunk['data']['xsize'],
      'ysize' => chunk['data']['ysize'],
      'zsize' => 1,
      'size' => chunk['data']['xsize'] * chunk['data']['ysize'] * 1,
      'data' => Array.new(chunk['data']['xsize'] * chunk['data']['ysize'] * 1, -1),
      'default' => -1,
      '&class' => 'Moon::DataMatrix'
    },
    'data' => chunk['data'],
    'tileset_id' => 'tilesets/common',
    '&class' => 'Models::Map',
  }

  target_filename = 'data/' + new_data['id'] + '.yml'
  FileUtils.mkdir_p File.dirname(target_filename)
  File.write(target_filename, new_data.to_yaml)
end
