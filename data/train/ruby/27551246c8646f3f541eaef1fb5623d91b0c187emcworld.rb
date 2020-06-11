
require 'magellan'
require 'magellan/mcdefs'
require 'magellan/mcentity'
require 'magellan/mcleveldat'

module Magellan

# The MC_World class manages the heirarchy of regions and chunks a Minecraft world
# is composed of, and provides facilities for editing and creating such worlds.
# 
# Chunks are segments of the world consisting of 16x16 columns of (currently)
# 128 blocks, the block types and other data being held in arrays.
# Regions are larger segments of the world, 32x32 chunks in size, some of which may
# be empty.
# 
# Chunks do not have a full class at this time, they are simple hashes:
# chunk = {
#     region: region,
#     region_coords: [region_chunk_x, region_chunk_z],
#     nbt: chunk_nbt,
#     blocks: chunk_nbt[:Level][:Blocks].value,
#     block_data: chunk_nbt[:Level][:Data].value,
#     dirty: true/false,
#     accessed: incrementing integer
# }

# Region-relative coordinates of the chunks contained within the region
CHUNK_COORDS = (0..31).to_a.product((0..31).to_a)

class MC_World
    attr_reader :level_dat, :world_dir, :world_name, :all_regions
    
    def initialize(opts = {})
        # @gen_chunks = opts.fetch(:gen_chunks, true)
        @all_regions = {}
        if(opts[:world_dir])
            load_world(opts[:world_dir])
        elsif(opts[:world_name])
            load_world("#{MCPATH}/saves/#{opts[:world_name]}")
        end
    end
    
    # Load world...opens all region files and level.dat for world, does not load any chunks.
    def load_world(world_dir)
        @world_dir = world_dir
        @world_name = world_dir.split('/')[-1]
        region_files = Dir.glob("#{@world_dir}/region/r.*.mcr")
        # region_files = Dir.entries("#{@world_dir}/region")
        # region_files.delete('.')
        # region_files.delete('..')
        
        region_files.each {|fin|
            # Extract coordinates from file name. File name format is r.X.Y.mcr
            coords = fin.split('.')[1, 2]
            region = MCRegion.new
            if(region.open(fin) == 0)
            # if(region.open("#{@world_dir}/region/#{fin}") == 0)
                @all_regions[coords] = region
            end
        }
        coords = @all_regions.keys
        @minmax_x = (coords.map {|coord| coord[0]}).minmax
        @minmax_z = (coords.map {|coord| coord[1]}).minmax
        
        @level_dat = MC_LevelDat.new({world_dir: world_dir})
        
        @slock = File.new("#{@world_dir}/session.lock", "wb")
        
        # Update session.lock
        @slock.rewind
        ts = mc_timestamp()
        tsbytes = (0..7).map {|x| (ts >> (8*(7-x))) & 0xFF}
        @slock.write(tsbytes.pack("CCCCCCCC"))
        
        @chunks = {}
    end
    
    def compute_lights()
        compute_lights_intern()
    end
    
    def compute_heights()
        compute_heights_intern()
    end
    
    def mc_timestamp()
        ts = (Time.now.to_r*1000).to_i
    end
    
    # Generate a new chunk for each empty chunk in specified area
    # def fill_empty_chunks(xrange, zrange)
    # end
    
    # Iterate over each non-empty chunk in the world, calling block on each.
    def each_chunk(fn)
        @all_regions.each_key {|rgmcoord|
            CHUNK_COORDS.each {|chunkcoord|
                chunk = get_chunk(rgmcoord[0] + chunkcoord[0], rgmcoord[1] + chunkcoord[1])
                if(chunk)
                    yield(chunk)
                end
            }
        }
    end

    def each_entity_nbt(fn)
        each_chunk {|chunk| chunk[:entities].each {|ent| yield(ent)}}
    end

    def each_tile_entity_nbt(fn)
        each_chunk {|chunk| chunk[:tile_entities].each {|ent| yield(ent)}}
    end
    
    def get_stats()
        stats = {}
        stats[:world_name] = @world_name
        stats[:world_dir] = @world_dir
        stats[:num_regions] = @all_regions.size
        stats[:range_x] = @minmax_x
        stats[:range_z] = @minmax_z
        stats[:total_chunks] = @all_regions.size*1024
        stats[:empty_chunks] = 0
        stats[:chunk_maps] = {}
        @all_regions.each {|rcoord, rgn|
            map = []
            (0..31).each {|z|
                map[z] = ''
                (0..31).each {|x|
                    if(rgn.chunk_exists(x, z) == true)
                        map[z] += ' *'
                    else
                        map[z] += ' .'
                    end
                }
            }
            stats[:chunk_maps][rcoord] = map
            CHUNK_COORDS.each {|coord|
                if(!rgn.chunk_exists(coord[0], coord[1]))
                    stats[:empty_chunks] += 1
                end
            }
        }
        stats
    end
    
    # Get NBT for chunk containing XZ block coordinates
    # Parameters are world XZ coordinates for any column of blocks in the desired chunk.
    # Loads NBT for chunk containing coordinates if not already loaded, or creates new one with
    # fill_empty_chunk() if chunk doesn't yet exist.
    # TODO: unload a chunk if more than a maximum number are loaded. Unload clean chunk if any
    # exist unless it was just loaded, otherwise write and unload least recently accessed chunk.
    def load_chunk(x, z)
        chunk_nbt = nil
        region = @all_regions[[x/512, z/512]]
        
        if(region)
            region_chunk_x = (x/16) & 31
            region_chunk_z = (z/16) & 31
            if(region.chunk_exists(region_chunk_x, region_chunk_z))
                chunk_nbt = region.read_chunk_nbt(region_chunk_x, region_chunk_z)
            end
        end
        
        if(chunk_nbt)
            level = chunk_nbt[:Level]
            chunk = {
                region: region,
                region_coords: [region_chunk_x, region_chunk_z],
                nbt: chunk_nbt,
                blocks: level[:Blocks].value,
                block_data: level[:Data].value,
                entities: level[:Entities].value,
                tile_entities: level[:TileEntities].value,
                dirty: false,
                accessed: 0
            }
            @chunks[[x/16, z/16]] = chunk
            chunk
        else
            nil
        end
    end
    
    def unload_chunk(chunk)
        chunk = @chunks.delete(chunk[:region_coords]) {raise "Attempt to unload chunk that isn't loaded"}
        if(chunk[:dirty])
            write_chunk(chunk)
        end
    end
    
    def write_chunk(chunk)
        # TODO: verify this. The value is described in the wiki as
        # "Tick when the chunk was last saved". Unclear whether
        # this is the same quantity written to the session lock file.
        chunk[:nbt][:Level][:LastUpdate].value = mc_timestamp()
        chunk[:region].write_chunk_nbt(x, z, chunk[:nbt])
        chunk[:dirty] = false
    end
    
    # Write all loaded/modified chunks to disk
    def write_chunks()
        @chunks.each {|chunk|
            if(chunk[:dirty])
                write_chunk(chunk)
            end
        }
    end
    
    # Get the chunk containing given coordinates
    # Parameters are world XZ coordinates for any column of blocks in the desired chunk.
    # If chunk not already loaded, attempts to load it.
    # If chunk doesn't exist, yields to block, passing chunk coordinates and returning result.
    # Do something like:
    # 
    # get_chunk(x, z) {|x, z| load_chunk(x, z)}
    # 
    # to automatically load chunks on access.
    def get_chunk(x, z)
        chunk = @chunks.fetch([x/16, z/16]) {load_chunk(x, z)}
        if(chunk == nil)
            chunk = yield(x, z)
        end
        if(chunk != nil)
            chunk[:accessed] = (@access_ctr += 1)
        end
        chunk
    end
    
    # region coordinates of region containing block
    def get_region_coords(block_coords)
        [block_coords[0]/512, block_coords[1]/512]
    end
    
    # chunk coordinates of chunk containing block
    def get_chunk_coords(block_coords)
        [block_coords[0]/16, block_coords[10]/16]
    end
    
    # Sets block type and data.
    def set_block2(x, y, z, bid, data)
        chunk = get_chunk(x, z)
        chunk[:dirty] = true
        
        blocks = chunk[:nbt][:Level][:Blocks].value
        block_data = chunk[:nbt][:Level][:Data].value
        
        # Set block
        bidx = ((x & 15)*16 + (z & 15))*128 + y
        blocks.setbyte(bidx, bid)
        
        # Set data
        halfidx = bidx >> 1;
        data_byte = block_data.getbyte(halfidx)
        if(bidx & 0x01)
            data_byte = (data << 4) | (data_byte & 0x0F);
        else
            data_byte = (data_byte & 0xF0) | (data & 0x0F);
        end
        block_data.setbyte(halfidx, data_byte)
    end
    
    # Get block type and data
    def get_block2(x, y, z)
        chunk = get_chunk(x, z)
        bidx = ((x & 15)*16 + (z & 15))*128 + y
        [chunk[:blocks].getbyte(bidx), chunk[:block_data].getbyte(bidx >> 1)]
    end
    
    # Find first empty block location immediately above a non-empty block,
    # starting from given location.
    def find_drop_pt(x, y, z)
        chunk = get_chunk(x, z)
        
    end
end # class MC_World

end # module Magellan
