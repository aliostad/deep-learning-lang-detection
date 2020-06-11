# coding: utf-8

module ENCRYPT

    CHUNK_SIZE = 30

    # RSA

    # return x ** y % z, more effective
    def enctypt(x, y, z)
        result = 1
        while y > 0
            result = result * x % z if y & 1 == 1
            y >>= 1
            x = x * x % z
        end
        result
    end

    def enctypt_chunk(e, m, chunk)
        chunk = chunk.bytes.to_a

        chunk << 0 unless chunk.length % 2 == 0

        nums = Array.new(chunk.length / 2) {|i| chunk[2 * i] + (chunk[2 * i + 1] << 8)}

        c = 0
        nums.each_with_index{|v, i| c += (v << i * 16)}

        encypted = enctypt(c, e, m)

        encypted.to_s(16)
    end

    def encrypt_string(e, m, s)
        e, m = e.hex, m.hex

        chunks = s.length > CHUNK_SIZE ? [s.slice(0, CHUNK_SIZE), s.slice(CHUNK_SIZE, s.length - CHUNK_SIZE)] : [s]
        chunks.map {|c| enctypt_chunk(e, m, c)}.join('')
    end

end
