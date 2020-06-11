extern "C"
{
#include "Api.h"
#include "FakeUptime.h"
#include "hardware/FakePwm.h"
}

#include "CppUTest/TestHarness.h"

TEST_GROUP(Api)
{
	Api api;

	void setup()
	{
		api = Api_Create();
    Uptime_Create();
	}

	void teardown()
	{
		Api_Destroy(api);
    Uptime_Destroy();
  }

  void SpeedIs(double speed)
  {
    DOUBLES_EQUAL(Api_GetTargetSpeed(api), speed, 0.01);
  }

  long Hours(double hours)
  {
    return hours*60*60*1000;
  }
};

TEST(Api, ItStatsAtZeroSpeed)
{
  SpeedIs(0.0);
}

TEST(Api, itSetsTheTargetSpeed)
{
  Api_SetTargetSpeed(api, 1.0);
  SpeedIs(1.0);
}

TEST(Api, itIncrementsTheTargetSpeed)
{
  Api_SetTargetSpeed(api, 1.0);
  Api_IncrementTargetSpeed(api);
  SpeedIs(1.1);
}

TEST(Api, itDecrementsTheTargetSpeed)
{
  Api_SetTargetSpeed(api, 1.0);
  Api_DecrementTargetSpeed(api);
  SpeedIs(0.9);
}

TEST(Api, itHasMaxSpeed)
{
  Api_SetTargetSpeed(api, 3.0);
  Api_SetMaximumSpeed(api, 3.0);
  Api_IncrementTargetSpeed(api);
  SpeedIs(3.0);
}

TEST(Api, itTracksDistanceTraveled)
{
  Api_SetTargetSpeed(api, 1.0);
  uptimeMillis = Hours(1);
  DOUBLES_EQUAL(1.0, Api_DistanceTravelled(api), 0.01);
}

TEST(Api, itTrackDistanceTraveledWithSpeedChanges)
{
  Api_SetTargetSpeed(api, 1.0);
  uptimeMillis = Hours(1);
  Api_SetTargetSpeed(api, 2.0);
  uptimeMillis = Hours(2);
  DOUBLES_EQUAL(3.0, Api_DistanceTravelled(api), 0.01);
}

TEST(Api, itResetsDistanceTraveled)
{
  Api_SetTargetSpeed(api, 1.0);
  uptimeMillis = Hours(1);
  Api_Reset(api);
  DOUBLES_EQUAL(0.0, Api_DistanceTravelled(api), 0.01);
}

TEST(Api, itSetsPwm)
{
  Api_SetTargetSpeed(api, 1.0);
  CHECK(FakePwm_isRunning);
  LONGS_EQUAL(FakePwm_period, 50000);
  DOUBLES_EQUAL(FakePwm_dutyCycle, 0.242, 0.001);

}
