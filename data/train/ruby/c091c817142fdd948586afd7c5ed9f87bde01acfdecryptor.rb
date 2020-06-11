require "./lib/key_generator"
require "./lib/date_generator"
require "./lib/cipher"
require "./lib/offset_generator"
require "Date"

class Decryptor
  attr_reader :key, :date, :cipher, :encrypted_message, :og, :keyword, :final_date

  def initialize
    @cipher = Cipher.new
    @encrypted_message = []
  end

  def date_generation
    DateGenerator.new(date).date
  end

  def create_offset(key, date)
    OffsetGenerator.new(key, date)
  end

  def decrypt(message, key, date=nil)
    key = key || KeyGenerator.new.key
    @keyword = key
    date = date || date_generation
    @final_date = date
    og = create_offset(key, date)
    chunk_message = []
    message.downcase!
    message.split("").each_slice(6) {|a| chunk_message << a }
    chunk_message.each do |chunk|
      rotate_chunk(- og.a_rotation, chunk[0])
      rotate_chunk(- og.b_rotation, chunk[1])
      rotate_chunk(- og.c_rotation, chunk[2])
      rotate_chunk(- og.d_rotation, chunk[3])
      rotate_chunk(- og.e_rotation, chunk[4])
      rotate_chunk(- og.f_rotation, chunk[5])
    end
    encrypted_message.flatten.join
  end

  def rotate_chunk(letter_rotation, chunk_position)
    cipher.rotate_characters(letter_rotation)
    encrypted_message << cipher.rotated_pairs[chunk_position]
  end
end


if __FILE__ == $0
  encrypted_message = File.read(ARGV[0])

  d = Decryptor.new
  decrypted_message = d.decrypt(encrypted_message.chomp, ARGV[2])
  File.write(ARGV[1], decrypted_message)
  puts "Created #{ARGV[1]} with the key #{d.keyword} and date #{d.final_date}"
end
