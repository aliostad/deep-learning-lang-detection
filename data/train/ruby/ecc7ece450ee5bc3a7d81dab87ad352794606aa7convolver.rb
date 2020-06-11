# NArray-based raster processing library for use with the expression-parser
# library.  
#
# Author:: Pramukta Kumar (mailto: prak@mac.com)
# Copyright:: Pramukta Kumar
# License:: MIT Public License
#
require 'rubygems'
require 'fftw3'

module Pixelate
  # A class that implements an overlap-add fft based convolution method.  The input
  # data and parameters are provided in the constructor and the instance can persist.
  # this allows partial areas to be computed and the instance can be kept around in
  # order to implement tiling.
  class Convolver
    attr_reader :raster
    attr_reader :kernel
    attr_reader :chunk_size
    attr_reader :result

    def initialize(raster, kernel, chunk_size=256)
      @width, @height = raster.shape
      # protect the method from some forms of invalid input
      if(kernel.shape[0] > chunk_size || kernel.shape[1] > chunk_size)
        raise ArgumentError, %Q{Kernel cannot be larger than the Chunk Size
Kernel Size: #{kernel.shape[0]} x #{kernel.shape[1]}
Chunk Size: #{chunk_size}
}
      end
      if(kernel.shape[0] > raster.shape[0] || kernel.shape[1] > raster.shape[1])
        raise ArgumentError, %Q{Kernel cannot be larger than the Raster
Kernel Size: #{kernel.shape[0]} x #{kernel.shape[1]}
Raster Size: #{raster.shape[0]} x #{raster.shape[1]}
}
      end
      if(raster.is_a?(Raster))
        raster = raster.buffer
      end
      unless(raster.is_a?(NArray) && raster.shape.length == 2)
        raise ArgumentError, %Q{Input Raster doesn't seem right.  Check to make sure that it is a 2-D NArray (or Pixelate::Raster)}
      end
      # end input protection section
        
      @chunk_size = chunk_size      
      @raster = zero_pad_raster(raster, chunk_size)
      @kernel = zero_pad_kernel(kernel, chunk_size)
      @result = NArray.float(*@raster.shape)
      width, height = @raster.shape
      @computed_chunks = NArray.byte(width / chunk_size, 
                                     height / chunk_size)
    end
  
    def convolve(xrange=(1..(@computed_chunks.shape[0] - 1)), 
                 yrange=(1..(@computed_chunks.shape[1] - 1)) )
      # protect the method from some forms of invalid input
      if(xrange.is_a?(Numeric))
        xrange = xrange..xrange
      end
      if(yrange.is_a?(Numeric))
        yrange = yrange..yrange
      end
      unless( (1..(@computed_chunks.shape[0])).include?(xrange.first) &&
          (1..(@computed_chunks.shape[0])).include?(xrange.last) &&
          (1..(@computed_chunks.shape[1])).include?(yrange.first) &&
          (1..(@computed_chunks.shape[1])).include?(yrange.last) )
        raise IndexError, %Q{Ranges are out of bounds
Selected Ranges: #{xrange}, #{yrange}
Valid Ranges: #{1..(@computed_chunks.shape[0])}, #{1..(@computed_chunks.shape[1])}
}
      end
      # end protection section
      width, height = @raster.shape
      kernel_fft = FFTW3.fft(@kernel)
      xrange.each do |x|
        yrange.each do |y|
          if(@computed_chunks[x-1, y-1] == 0)
            chunk = working_chunk(x, y)
            chunk_fft = FFTW3.fft(chunk)
            result_chunk = swap_quadrants(FFTW3.ifft(kernel_fft * chunk_fft) / (@chunk_size * @chunk_size * 4).to_f)
            accumulate_result_chunk(x, y, result_chunk.real)
            # image = Pixelate::Raster.from_narray(chunk).to_image
            # image.write("#{x}_#{y}.png")
            @computed_chunks[x - 1, y - 1] = 1
          end
        end
      end
      # return a cropped out section of the result raster
      # need this to work for sub ranges too
      r1, r2 = chunk_ranges(xrange.first, yrange.first)
      r3, r4 = chunk_ranges(xrange.last, yrange.last)
      
      delta = (@chunk_size) / 2
      
      @result[(r1.first + delta)..([r3.last - delta, r1.first + delta + @width - 1].min), 
        (r2.first + delta)..([r4.last - delta, r2.first + delta + @height - 1].min)]
    end
  
    private
    def accumulate_result_chunk(x, y, data)
      r1, r2 = chunk_ranges(x,y)
      @result[r1, r2] = @result[r1, r2] + data
    end
    # extracts a working window of 2*chunk_size x 2*chunk_size around the appropriate
    # raster chunk (indexing starts at 1)
    def working_chunk(x, y)
      r1, r2 = chunk_ranges(x, y)
      delta = (@chunk_size) / 2
      r1 = (r1.first + delta)..(r1.last - delta)
      r2 = (r2.first + delta)..(r2.last - delta)
      r = NArray.float(2*@chunk_size, 2*@chunk_size)
      r[(@chunk_size/2)..(2*@chunk_size - @chunk_size/2 - 1), (@chunk_size/2)..(2*@chunk_size - @chunk_size/2 - 1)] = @raster[r1, r2]
      return r
    end
    
    def chunk_ranges(x, y)
      a = ((x - 1) * chunk_size).to_i
      b = a + 2 * chunk_size - 1
      c = ((y - 1) * chunk_size).to_i
      d = c + 2 * chunk_size - 1
      [a..b, c..d]
    end
    
    # makes the raster dimensions divisible by the chunk_size and then adds a border
    # of chunk_size / 2 around the whole thing
    def zero_pad_raster(raster, chunk_size)
      width, height = raster.shape
      # set up the dimensions of the padded raster
      width = chunk_size * (width.to_f / chunk_size.to_f).ceil + chunk_size
      height = chunk_size * (height.to_f / chunk_size.to_f).ceil + chunk_size
      # set up the new raster
      r = NArray.float(width, height)
      # set up ranges to populate content of the new raster
      a = chunk_size / 2
      b = a + raster.shape[0] - 1
      c = chunk_size / 2
      d = c + raster.shape[1] - 1 
      r[a..b, c..d] = raster
      return r
    end
    
    def zero_pad_kernel(kernel, chunk_size)
      r = NArray.float(2*chunk_size, 2*chunk_size)
      a = r.shape[0] / 2 - ((kernel.shape[0] - 1) / 2)
      b = r.shape[0] / 2 + ((kernel.shape[0] - 1) / 2)
      c = r.shape[1] / 2 - ((kernel.shape[1] - 1) / 2)
      d = r.shape[1] / 2 + ((kernel.shape[1] - 1) / 2)
      r[a..b, c..d] = kernel
      return r
    end
    
    def swap_quadrants(fft_raster)
      width, height = fft_raster.shape
      result = NArray.complex(width, height)
      
      result[0..(width/2 - 1), 0..(height/2 - 1)] = fft_raster[(width/2)..(width - 1), (height/2)..(height - 1)]
      result[0..(width/2 - 1), (height/2)..(height - 1)] = fft_raster[(width/2)..(width - 1), 0..(height/2 - 1)]
      result[(width/2)..(width - 1), 0..(height/2 - 1)] = fft_raster[0..(width/2 - 1), (height/2)..(height - 1)]
      result[(width/2)..(width - 1), (height/2)..(height - 1)] = fft_raster[0..(width/2 - 1), 0..(height/2 - 1)]      
      
      return result
    end
  end
end