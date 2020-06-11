package com.os.snapshot

import com.os.dao.HBaseService
import com.os.settings.Settings
import com.typesafe.config.ConfigFactory
import org.junit.runner.RunWith
import org.scalatest.FlatSpec
import org.scalatest.junit.JUnitRunner
import org.scalatest.matchers.ShouldMatchers

/**
 * @author Vadim Bobrov
 */
@RunWith(classOf[JUnitRunner])
class SnapshotBaseTest extends FlatSpec with ShouldMatchers {

	Settings.load(ConfigFactory.parseString("write.snapshot-expiration = 5 days"))
	val test = new SnapshotBase(HBaseService("test"))
	import test._

	"splitting name" should "work" in {
		splitName("msmt12345") should be (("msmt", 12345))
		splitName("istate1992837645") should be (("istate", 1992837645))
	}

	"finding last snapshots" should "find all with the last timestamp" in {
		lastSnapshots("msmt123" :: "ismt123" :: "msmt124" :: "ismt124" :: Nil) should be ("msmt124" :: "ismt124" :: Nil)
	}

	"finding old snapshots" should "find all snapshots older than the setting" in {
		val newTimestamp = System.currentTimeMillis()
		val oldTimestamp = System.currentTimeMillis() - Settings().getFiniteDuration("write.snapshot-expiration").toMillis - 1000
		oldSnapshots(s"msmt$newTimestamp" :: s"ismt$newTimestamp" :: s"msmt$oldTimestamp" :: s"ismt$oldTimestamp" :: Nil, Settings().getFiniteDuration("write.snapshot-expiration")) should be (s"msmt$oldTimestamp" :: s"ismt$oldTimestamp" :: Nil)
	}

}
