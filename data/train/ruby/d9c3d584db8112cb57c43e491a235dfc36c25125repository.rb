module FWD
  class Repository
    
    def self.register_scene(scene)
      @scenes ||= Array.new
      @scenes << scene
    end
    
    def unregister_scene(scene)
      return unless @scenes
      @screnes.delete(scene)
    end
    
    
    def self.register(obj)
      @repository ||= Hash.new
      
      @repository[obj.class] ||= Array.new
      @repository[obj.class] << obj unless @repository[obj.class].include? obj
    end
    
    def self.unregister(obj)
      return unless @repository || @repository[obj.class]
      @scenes ||= Array.new
      @scenes.each {|scene| scene.remove(obj)}
      @repository[obj.class].delete(obj)
    end
  end
end