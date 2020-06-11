package jackdaw.remote

import java.io._

import jackdaw.player._
import jackdaw.data._
	
final class Output(val st:OutputStream) {
	def writeToStub(it:ToStub):Unit	= {
		it match {
			case x@StartedStub(_,_)	=> writeByte(0); writeStartedStub(x)
			case x@SendStub(_)		=> writeByte(1); writeSendStub(x)
		}
	}
	def writeStartedStub(it:StartedStub):Unit	= {
		writeInt(it.outputRate)
		writeBoolean(it.phoneEnabled)
	}
	def writeSendStub(it:SendStub):Unit	= {
		writeEngineFeedback(it.feedback)
	}
	def writeEngineFeedback(it:EngineFeedback):Unit	= {
		writeFloat(it.masterPeak)
		writePlayerFeedback(it.player1)
		writePlayerFeedback(it.player2)
		writePlayerFeedback(it.player3)
	}
	def writePlayerFeedback(it:PlayerFeedback):Unit	= {
		writeBoolean(it.running)
		writeBoolean(it.afterEnd)
		writeDouble(it.position)
		writeDouble(it.pitch)
		writeOption(it.measureMatch ,writeDouble)
		writeOption(it.beatRate, writeDouble)
		writeBoolean(it.needSync)
		writeBoolean(it.hasSync)
		writeFloat(it.masterPeak)
		writeOption(it.loopSpan, writeSpan)
		writeOption(it.loopDef, writeLoopDef)
	}
	def writeSpan(it:Span):Unit = {
		writeDouble(it.start)
		writeDouble(it.size)
	}
	def writeLoopDef(it:LoopDef):Unit = {
		writeInt(it.measures)
	}
	
	//------------------------------------------------------------------------------
	
	def writeToSkeleton(it:ToSkeleton):Unit	= {
		it match {
			case KillSkeleton		=> writeByte(0); writeKillSkeleton(KillSkeleton)
			case x@SendSkeleton(_)	=> writeByte(1); writeSendSkeleton(x)
		}
	}
	def writeKillSkeleton(it:KillSkeleton.type):Unit = {}
	def writeSendSkeleton(it:SendSkeleton):Unit = {
		writeEngineAction(it.action)
	}
	def writeEngineAction(it:EngineAction):Unit = {
		it match {
			case x@EngineChangeControl(_,_)	=> writeByte(0); writeEngineChangeControl(x)
			case x@EngineSetBeatRate(_)		=> writeByte(1); writeEngineSetBeatRate(x)
			case x@EngineControlPlayer(_,_)	=> writeByte(2); writeEngineControlPlayer(x)
		}
	}
	def writeEngineChangeControl(it:EngineChangeControl):Unit = {
		writeDouble(it.speaker)
		writeDouble(it.phone)
	}
	def writeEngineSetBeatRate(it:EngineSetBeatRate):Unit = {
		writeDouble(it.beatRate)
	}
	def writeEngineControlPlayer(it:EngineControlPlayer):Unit = {
		writeInt(it.player)
		writePlayerAction(it.action)
	}
	def writePlayerAction(it:PlayerAction):Unit = {
		it match {
			case x@PlayerChangeControl(_,_,_,_,_,_,_)	=> writeByte(0);	writePlayerChangeControl(x)
			case x@PlayerSetNeedSync(_)					=> writeByte(1);	writePlayerSetNeedSync(x)
			case x@PlayerSetFile(_)						=> writeByte(2);	writePlayerSetFile(x)
			case x@PlayerSetRhythm(_)					=> writeByte(3);	writePlayerSetRhythm(x)
			case x@PlayerSetRunning(_)					=> writeByte(4);	writePlayerSetRunning(x)
			case x@PlayerPitchAbsolute(_,_)				=> writeByte(5);	writePlayerPitchAbsolute(x)
			case x@PlayerPhaseAbsolute(_)				=> writeByte(6);	writePlayerPhaseAbsolute(x)
			case x@PlayerPhaseRelative(_)				=> writeByte(7);	writePlayerPhaseRelative(x)
			case x@PlayerPositionAbsolute(_)			=> writeByte(8);	writePlayerPositionAbsolute(x)
			case x@PlayerPositionJump(_,_)				=> writeByte(9);	writePlayerPositionJump(x)
			case x@PlayerPositionSeek(_)				=> writeByte(10);	writePlayerPositionSeek(x)
			case x@PlayerDragAbsolute(_)				=> writeByte(11);	writePlayerDragAbsolute(x)
			case PlayerDragEnd							=> writeByte(12);	writePlayerDragEnd(PlayerDragEnd)
			case x@PlayerScratchRelative(_)				=> writeByte(13);	writePlayerScratchRelative(x)
			case PlayerScratchEnd						=> writeByte(14);	writePlayerScratchEnd(PlayerScratchEnd)
			case x@PlayerLoopEnable(_)					=> writeByte(15);	writePlayerLoopEnable(x)
			case PlayerLoopDisable						=> writeByte(16);	writePlayerLoopDisable(PlayerLoopDisable)
		}
	}
	def writePlayerChangeControl(it:PlayerChangeControl):Unit	= {
		writeDouble(it.trim);
		writeDouble(it.filter);
		writeDouble(it.low);
		writeDouble(it.middle);
		writeDouble(it.high);
		writeDouble(it.speaker);
		writeDouble(it.phone);
	}
	def writePlayerSetNeedSync(it:PlayerSetNeedSync):Unit	= {
		writeBoolean(it.needSync)
	}
	def writePlayerSetFile(it:PlayerSetFile):Unit	= {
		writeOption(it.file, writeFile)
	}
	def writePlayerSetRhythm(it:PlayerSetRhythm):Unit	= {
		writeOption(it.rhythm, writeRhythm)
	}
	def writePlayerSetRunning(it:PlayerSetRunning):Unit	= {
		writeBoolean(it.running)
	}
	def writePlayerPitchAbsolute(it:PlayerPitchAbsolute):Unit	= {
		writeDouble(it.pitch)
		writeBoolean(it.keepSync)
	}
	def writePlayerPhaseAbsolute(it:PlayerPhaseAbsolute):Unit	= {
		writeRhythmValue(it.position)
	}
	def writePlayerPhaseRelative(it:PlayerPhaseRelative):Unit	= {
		writeRhythmValue(it.offset)
	}
	def writePlayerPositionAbsolute(it:PlayerPositionAbsolute):Unit	= {
		writeDouble(it.frame)
	}
	def writePlayerPositionJump(it:PlayerPositionJump):Unit	= {
		writeDouble(it.frame)
		writeRhythmUnit(it.rhythmUnit)
	}
	def writePlayerPositionSeek(it:PlayerPositionSeek):Unit	= {
		writeRhythmValue(it.offset)
	}
	def writePlayerDragAbsolute(it:PlayerDragAbsolute):Unit	= {
		writeDouble(it.v)
	}
	def writePlayerDragEnd(it:PlayerDragEnd.type):Unit	= {}
	def writePlayerScratchRelative(it:PlayerScratchRelative):Unit	= {
		writeDouble(it.frames)
	}
	def writePlayerScratchEnd(it:PlayerScratchEnd.type):Unit	= {}
	def writePlayerLoopEnable(it:PlayerLoopEnable):Unit	= {
		writeLoopDef(it.preset)
	}
	def writePlayerLoopDisable(it:PlayerLoopDisable.type):Unit	= {}
	
	def writeFile(it:File):Unit	= {
		writeString(it.getPath)
	}
	def writeRhythm(it:Rhythm):Unit	= {
		writeDouble(it.anchor)
		writeDouble(it.measure)
		writeSchema(it.schema)
	}
	def writeSchema(it:Schema):Unit	= {
		writeInt(it.measuresPerPhrase)
		writeInt(it.beatsPerMeasure)
	}
	def writeRhythmValue(it:RhythmValue):Unit	= {
		writeDouble(it.steps)
		writeRhythmUnit(it.unit)
	}
	def writeRhythmUnit(it:RhythmUnit):Unit	= {
		it match {
			case Phrase		=> writeByte(0)
			case Measure	=> writeByte(1)
			case Beat		=> writeByte(2)
		}
	}
	
	//------------------------------------------------------------------------------
	
	def writeOption[T](value:Option[T], writeSub:T=>Unit):Unit	= {
		value match {
			case Some(x)	=>
				writeBoolean(true)
				writeSub(x)
			case None	=>
				writeBoolean(false)
		}
	}
	
	def writeString(it:String):Unit	= {
		writeByteArray(it getBytes "UTF-8")
	}
	
	//------------------------------------------------------------------------------
	
	def writeByte(it:Byte):Unit	= {
		st write it
	}
	def writeShort(it:Short):Unit	= {
		writeByte((it >> 8).toByte)
		writeByte((it >> 0).toByte)
	}
	def writeInt(it:Int):Unit	= {
		writeByte((it >> 24).toByte)
		writeByte((it >> 16).toByte)
		writeByte((it >>  8).toByte)
		writeByte((it >>  0).toByte)
	}
	def writeLong(it:Long):Unit	= {
		writeByte((it >> 56).toByte)
		writeByte((it >> 48).toByte)
		writeByte((it >> 40).toByte)
		writeByte((it >> 32).toByte)
		writeByte((it >> 24).toByte)
		writeByte((it >> 16).toByte)
		writeByte((it >>  8).toByte)
		writeByte((it >>  0).toByte)
	}
	
	def writeFloat(it:Float):Unit	= {
		writeInt(java.lang.Float floatToIntBits it)
	}
	def writeDouble(it:Double):Unit	= {
		writeLong(java.lang.Double doubleToLongBits it)
	}
	
	def writeBoolean(it:Boolean):Unit	= {
		writeByte(if (it) 1 else 0)
	}
	def writeChar(it:Char):Unit	= {
		writeShort(it.toShort)
	}

	def writeByteArray(it:Array[Byte]):Unit	= {
		writeInt(it.length)
		st write it
	}
}
