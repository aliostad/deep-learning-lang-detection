import org.infinispan.notifications.Listener
import org.infinispan.notifications.cachemanagerlistener.annotation._
import org.infinispan.notifications.cachemanagerlistener.event._

//@Listener
//@Listener(sync = true)
@Listener(sync = false)
class CacheManagerLevelListener extends ThreadNameLogSupport
                                with SimpleClassNameLogSupport {
  @CacheStarted
  def cacheStarted(event: CacheStartedEvent): Unit =
    log(s"キャッシュ開始イベント => ${event.getCacheName}")

  @CacheStopped
  def cacheStopped(event: CacheStoppedEvent): Unit =
    log(s"キャッシュ停止イベント => ${event.getCacheName}")

  @ViewChanged
  def viewChanged(event: ViewChangedEvent): Unit =
    log(s"ビュー変更イベント => isMergeView? => ${event.isMergeView}, viewId => ${event.getViewId}, localAddress => ${event.getLocalAddress}, getOldMembers => ${event.getOldMembers}, getNewMembers => ${event.getNewMembers}")

  @Merged
  def merged(event: MergeEvent): Unit =
    log(s"マージイベント => ${event.getSubgroupsMerged}, isMergeView? => ${event.isMergeView}, viewId => ${event.getViewId}, localAddress => ${event.getLocalAddress}, getOldMembers => ${event.getOldMembers}, getNewMembers => ${event.getNewMembers}")
}
