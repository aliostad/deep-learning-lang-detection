require 'rubygems'
require 'gosu'
class Frontend < Gosu::Window
    attr_accessor :processes
    def initialize width, height
        super width, height, false
        self.caption = "Rdiv"
        @processes = {}
        @mouse_down = false
    end
    def set_background_image path
        @background_image = Gosu::Image.new(self, path, true)
    end
    def push_process process
        image = nil
        if process.animated.nil?
            if process.text.nil?
                image = Gosu::Image.new(self, process.get_image_path(), true)
                process.width = process.scale * image.width
                process.height = process.scale * image.height
            else
                image = Gosu::Font.new(self, Gosu::default_font_name, 20)
                process.width = 0
                process.height = 0
            end
        else
            image = Gosu::Image.load_tiles(self, process.get_image_path(),
                                           -process.n_x, -process.n_y, true)
            process.width = process.scale * image[0].width
            process.height = process.scale * image[0].height
        end
        sound_path = process.get_sound_path()
        Gosu::Sample.new(sound_path).play if File.exists? sound_path
        @processes[process] = image
    end
    def delete_process process
        @processes.delete process
    end
    def button_down(id)
        case id
        when Gosu::MsLeft
            @mouse_down = true
        end
    end
    def button_up(id)
        case id
        when Gosu::MsLeft
            @mouse_down = false
        end
    end
    def set_mouse mouse
        mouse.x = mouse_x
        mouse.y = mouse_y
        mouse.left = @mouse_down
    end
    def draw
        @background_image.draw(0, 0, 0) if not @background_image.nil?
        @processes.each do |process, image|
            if process.text
                image.draw(process.text, process.x, process.y, 0, 1.0, 1.0, process.color)
            else
                image = image[process.i] if process.animated
                image.draw_rot(process.x, process.y,
                               1, 0, 0.5, 0.5, process.scale, process.scale)
            end
        end
    end
    def update
        @_proc.call if not @_proc.nil?
    end
    def run _proc
        @_proc = _proc
        show
    end
end

