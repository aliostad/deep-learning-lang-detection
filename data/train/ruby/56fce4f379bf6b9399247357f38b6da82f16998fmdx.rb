require "./binarystream"
require "./classes"

class Mdx
	def initialize (file)
		puts("Loading #{file}")
		
		@stream = BinaryStream.new(file)
		@versionChunk = nil
		@modelChunk = nil
		@sequenceChunk = nil
		@globalSequenceChunk = nil
		@textureChunk = nil
		@layerChunk = nil
		@materialChunk = nil
		@textureAnimationChunk = nil
		@geosetChunk = nil
		@geosetAnimationChunk = nil
		@boneChunk = nil
		@lightChunk = nil
		@helperChunk = nil
		@attachmentChunk = nil
		@pivotPointChunk = nil
		@particleEmitterChunk = nil
		@particleEmitter2Chunk = nil
		@ribbonEmitterChunk = nil
		@eventObjectChunk = nil
		@cameraChunk = nil
		@collisionShapeChunk = nil
		
		parse()
	end
	
	def export (target)
		
	end
	
	def info ()
		s = "Info of #{self}:\n"
		s += @versionChunk.info(1) if not @versionChunk.nil?
		s += @modelChunk.info(1) if not @modelChunk.nil?
		s += @sequenceChunk.info(1) if not @sequenceChunk.nil?
		s += @globalSequenceChunk.info(1) if not @globalSequenceChunk.nil?
		s += @textureChunk.info(1) if not @textureChunk.nil?
		s += @layerChunk.info(1) if not @layerChunk.nil?
		s += @materialChunk.info(1) if not @materialChunk.nil?
		s += @textureAnimationChunk.info(1) if not @textureAnimationChunk.nil?
		s += @geosetChunk.info(1) if not @geosetChunk.nil?
		s += @geosetAnimationChunk.info(1) if not @geosetAnimationChunk.nil?
		s += @boneChunk.info(1) if not @boneChunk.nil?
		s += @lightChunk.info(1) if not @lightChunk.nil?
		s += @helperChunk.info(1) if not @helperChunk.nil?
		s += @attachmentChunk.info(1) if not @attachmentChunk.nil?
		s += @pivotPointChunk.info(1) if not @pivotPointChunk.nil?
		s += @particleEmitterChunk.info(1) if not @particleEmitterChunk.nil?
		s += @particleEmitter2Chunk.info(1) if not @particleEmitter2Chunk.nil?
		s += @ribbonEmitterChunk.info(1) if not @ribbonEmitterChunk.nil?
		s += @eventObjectChunk.info(1) if not @eventObjectChunk.nil?
		s += @cameraChunk.info(1) if not @cameraChunk.nil?
		s += @collisionShapeChunk.info(1) if not @collisionShapeChunk.nil?
		
		return s
	end
	
	def tree ()
		s = "Tree:\n"
		s += @versionChunk.tree(1) if not @versionChunk.nil?
		s += @modelChunk.tree(1) if not @modelChunk.nil?
		s += @sequenceChunk.tree(1) if not @sequenceChunk.nil?
		s += @globalSequenceChunk.tree(1) if not @globalSequenceChunk.nil?
		s += @textureChunk.tree(1) if not @textureChunk.nil?
		s += @layerChunk.tree(1) if not @layerChunk.nil?
		s += @materialChunk.tree(1) if not @materialChunk.nil?
		s += @textureAnimationChunk.tree(1) if not @textureAnimationChunk.nil?
		s += @geosetChunk.tree(1) if not @geosetChunk.nil?
		s += @geosetAnimationChunk.tree(1) if not @geosetAnimationChunk.nil?
		s += @boneChunk.tree(1) if not @boneChunk.nil?
		s += @lightChunk.tree(1) if not @lightChunk.nil?
		s += @helperChunk.tree(1) if not @helperChunk.nil?
		s += @attachmentChunk.tree(1) if not @attachmentChunk.nil?
		s += @pivotPointChunk.tree(1) if not @pivotPointChunk.nil?
		s += @particleEmitterChunk.tree(1) if not @particleEmitterChunk.nil?
		s += @particleEmitter2Chunk.tree(1) if not @particleEmitter2Chunk.nil?
		s += @ribbonEmitterChunk.tree(1) if not @ribbonEmitterChunk.nil?
		s += @eventObjectChunk.tree(1) if not @eventObjectChunk.nil?
		s += @cameraChunk.tree(1) if not @cameraChunk.nil?
		s += @collisionShapeChunk.tree(1) if not @collisionShapeChunk.nil?
		
		return s
	end
	
	private
	
	def parse ()
		@stream.readCheck("MDLX")
		
		while header = @stream.readHeader()
			case header.token
				when "VERS" then @versionChunk = VersionChunk.new(@stream, header.size)
				when "MODL" then @modelChunk = ModelChunk.new(@stream, header.size)
				when "SEQS" then @sequenceChunk = SequenceChunk.new(@stream, header.size)
				when "GLBS" then @globalSequenceChunk = GlobalSequenceChunk.new(@stream, header.size)
				when "TEXS" then @textureChunk = TextureChunk.new(@stream, header.size)
				when "LAYS" then @layerChunk = LayerChunk.new(@stream, header.size)
				when "MTLS" then @materialChunk = MaterialChunk.new(@stream, header.size)
				when "TXAN" then @textureAnimationChunk = TextureAnimationChunk.new(@stream, header.size)
				when "GEOS" then @geosetChunk = GeosetChunk.new(@stream, header.size)
				when "GEOA" then @geosetAnimationChunk = GeosetAnimationChunk.new(@stream, header.size)
				when "BONE" then @boneChunk = BoneChunk.new(@stream, header.size)
				when "LITE" then @lightChunk = LightChunk.new(@stream, header.size)
				when "HELP" then @helperChunk = HelperChunk.new(@stream, header.size)
				when "ATCH" then @attachmentChunk = AttachmentChunk.new(@stream, header.size)
				when "PIVT" then @pivotPointChunk = PivotPointChunk.new(@stream, header.size)
				when "PREM" then @particleEmitterChunk = ParticleEmitterChunk.new(@stream, header.size)
				when "PRE2" then @particleEmitter2Chunk = ParticleEmitter2Chunk.new(@stream, header.size)
				when "RIBB" then @ribbonEmitterChunk = RibbonEmitterChunk.new(@stream, header.size)
				when "EVTS" then @eventObjectChunk = EventObjectChunk.new(@stream, header.size)
				when "CAMS" then @cameraChunk = CameraChunk.new(@stream, header.size)
				when "CLID" then @collisionShapeChunk = CollisionShapeChunk.new(@stream, header.size)
				else raise("This will never be shown")
			end
		end
	end
end