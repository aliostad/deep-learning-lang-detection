
public class api
{
	public static ApplicationGameController applicationGameController;
	public static PrefabController prefabController;
	public static PoolController poolController;
	public static AudioFXController audioFXController;
	
	public static TimelineController applicationTimelineController { get { return applicationGameController.timelineController; } }
	public static TweenController applicationTweenController { get { return applicationGameController.tweenController; } }
	
	public static TimelineController gameTimelineController { get { return applicationGameController.gameController.timelineController; } }
	public static TweenController gameTweenController { get { return applicationGameController.gameController.tweenController; } }
}
