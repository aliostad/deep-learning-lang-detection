#include <gtest/gtest.h>
#include <eina_types.h>

extern "C" {
#include "sound_volume_model.h"
}

class SoundVolumeModelTestSuite : public testing::Test {
	protected:
	virtual void SetUp() {
		SoundVolumeModel *model = (SoundVolumeModel *)malloc(sizeof(SoundVolumeModel));
		model->system = 9;
		model->notification = 9;
		model->alarm = 9;
		model->ringtone = 9;
		model->media = 9;
		model->voice = 9;
		sound_volume_model_set_current_volumes(model);
		free(model);
	}

	virtual void TearDown() {
	}
};

static void
check_volumes(SoundVolumeModel *model, int system, int notification, int alarm, int ringtone, int media, int voice) {
	ASSERT_EQ(model->system, system);
	ASSERT_EQ(model->notification, notification);
	ASSERT_EQ(model->alarm, alarm);
	ASSERT_EQ(model->ringtone, ringtone);
	ASSERT_EQ(model->media, media);
	ASSERT_EQ(model->voice, voice);
}

TEST_F(SoundVolumeModelTestSuite, test_sound_volume_model_get) {
	SoundVolumeModel *model = sound_volume_model_get_current_volumes_n();
	check_volumes(model, 9, 9, 9, 9, 9, 9);
	free(model);
}

TEST_F(SoundVolumeModelTestSuite, test_sound_volume_model_set) {
	SoundVolumeModel *model = (SoundVolumeModel *)malloc(sizeof(SoundVolumeModel));
	model->system = 1;
	model->notification = 2;
	model->alarm = 3;
	model->ringtone = 4;
	model->media = 5;
	model->voice = 6;

	sound_volume_model_set_current_volumes(model);

	SoundVolumeModel *after = sound_volume_model_get_current_volumes_n();
	check_volumes(after, 1, 2, 3, 4, 5, 6);

	free(model);
	free(after);
}

TEST_F(SoundVolumeModelTestSuite, test_sound_volume_model_mute) {
	sound_volume_model_mute();
	SoundVolumeModel *after = sound_volume_model_get_current_volumes_n();
	check_volumes(after, 0, 0, 0, 0, 0, 0);

	free(after);
}
