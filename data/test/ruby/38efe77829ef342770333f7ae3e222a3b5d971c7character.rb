class Character < ActiveRecord::Base
  mount_uploader :picture, PictureUploader

  belongs_to :player

  validates :name, presence: true  #, uniqueness: true
  validates :picture, presence: true
  validates :player_id, presence: true

  before_save :calculate_parameters!

  BaseParameter = 10
  ScaleFactor = 100
  AgeNumerator = 60
  DefaultAge = 1
  DefaultHitpoint = 1000

  def reset_hitpoints
    self.hitpoints = self.max_hitpoints
  end

  def calculate_parameters!(force = false)
    if self.new_record? || force
      colors = Miro::DominantColors.new(picture.current_path)
      ratio = colors.by_percentage
      logger.info "Color ratio: #{ratio}"

      self.attack = calculate_attack(ratio)
      self.defense = calculate_defense(ratio)
      self.speed = calculate_speed(ratio)
      self.max_hitpoints = calculate_hitpoints(ratio)
      self.hitpoints = self.max_hitpoints

      if FastImage.type(picture.current_path) == :jpeg
        exifr = EXIFR::JPEG.new(picture.current_path)
        self.age = calculate_age(exifr)
        self.luck = 1 # calculate_luck(exifr)
      else
        self.age = DefaultAge
        self.luck = 1
      end
    end
  end

  private
    def calculate_age(exifr)
      if exifr && exifr.f_number.to_f > 0
        (AgeNumerator / exifr.f_number.to_f).ceil
      else
        DefaultAge
      end
    end

    def calculate_attack(ratio)
      BaseParameter + ((ratio[0] || 0) * ScaleFactor).floor
    end

    def calculate_defense(ratio)
      BaseParameter + ((ratio[1] || 0)  * ScaleFactor).floor
    end

    def calculate_speed(ratio)
      BaseParameter + ((ratio[2] || 0) * ScaleFactor).floor
    end

    def calculate_hitpoints(ratio)
      if ratio.length == 1
        ratio.push 0
        ratio.push 0
      elsif ratio.length == 2
        ratio.push 0
      end

      DefaultHitpoint - (ratio.standard_deviation.abs * 1000).floor
    end
end
