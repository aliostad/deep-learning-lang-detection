package com.handknittedapps.honeycombmatchthree.external;

public class ExternalServiceRegistry
{
	private AdHandler adControlHandler;
	private RatingHandler ratingHandler;
	private AchievementHandler achievementHandler;
	private StatsHandler statsHandler;

	public void setAdHandler(AdHandler handler)
	{
		this.adControlHandler = handler;
	}

	public void setRatingHandler(RatingHandler handler)
	{
		this.ratingHandler = handler;
	}

	public void setAchievementHandler(AchievementHandler handler)
	{
		this.achievementHandler = handler;
	}

	public void setStatsHandler(StatsHandler handler)
	{
		this.statsHandler = handler;
	}

	public AdHandler getAdHandler()
	{
		return this.adControlHandler;
	}

	public RatingHandler getRatingHandler()
	{
		return this.ratingHandler;
	}

	public AchievementHandler getAchievementHandler()
	{
		return this.achievementHandler;
	}

	public StatsHandler getStatsHandler()
	{
		return this.statsHandler;
	}
}
