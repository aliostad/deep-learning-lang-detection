#include "GameLoadingScene.h"

#include "SpriteSheetLoadTask.h"
#include "MusicLoadTask.h"
#include "SoundEffectLoadTask.h"
#include "ChapterDataLoadTask.h"
#include "GameConfig.h"
#include "ChapterData.h"

#include "ScreenManager.h"

GameLoadingScene* GameLoadingScene::nodeWithChapter(int chapter, int level) {
  GameLoadingScene* scene = new GameLoadingScene(chapter, level);
  scene->autorelease();
  scene->init();
  return scene;
}

GameLoadingScene::GameLoadingScene(int chapter, int level) : chapter_(chapter), level_(level) {
  
}

void GameLoadingScene::setupTasks() {  
  loadTasks_.push(new SpriteSheetLoadTask("fonts.plist"));
  loadTasks_.push(new SpriteSheetLoadTask("game_assets.plist"));
  loadTasks_.push(new SpriteSheetLoadTask("game.plist"));
  loadTasks_.push(new SpriteSheetLoadTask("transition.plist"));
  
  switch (chapter_) {
    case 0:
      loadTasks_.push(new SpriteSheetLoadTask("country_backgrounds.plist"));
      break;
      
    case 1:
      loadTasks_.push(new SpriteSheetLoadTask("city_backgrounds.plist"));
      break;
      
    case 2:
      loadTasks_.push(new SpriteSheetLoadTask("jungle_backgrounds.plist"));
      break;
      
    default:
      break;
  }

  loadTasks_.push(new MusicLoadTask("kh_music_ingame_01.mp3"));
  
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_medium_01.mp3"));
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_medium_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_medium_03.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_medium_04.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_medium_05.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_medium_06.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_medium_07.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_medium_08.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_low_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_low_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_low_03.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_low_04.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_low_05.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_low_06.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_low_07.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_low_08.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_high_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_high_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_high_03.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_high_04.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_high_05.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_high_06.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_high_07.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_high_08.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_2nd_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_2nd_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_2nd_03.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_2nd_04.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_2nd_05.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_launch_2nd_06.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_idle_pose_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_idle_pose_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_idle_pose_03.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_idle_pose_04.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_idle_pose_05.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_full_power_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_full_power_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_full_power_03.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_full_power_04.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_full_power_05.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_full_power_06.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_full_power_07.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_full_power_08.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_falling_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_falling_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_falling_03.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_falling_04.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_falling_05.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_falling_06.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_cat_collect_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_cat_collect_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_cat_collect_03.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_cat_collect_04.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_cat_collect_05.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_cat_collect_06.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_voc_cat_collect_07.mp3")); 
  
  int levelCount = ChapterData::forChapter(chapter_).levels();
  for (int i = 0; i < levelCount; i++) {
    String filePath = String::withFormat("%d_%02d.level", chapter_ + 1, i + 1);
    loadTasks_.push(new ChapterDataLoadTask(filePath));    
  }
  
  
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_rocket_power_up_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_rocket_launch_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_rocket_full_power_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_pickup_good_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_pickup_cat_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_parachute_open_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_parachute_open_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_fail_horn_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_fail_horn_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_fail_horn_03.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_fail_horn_04.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_fail_horn_05.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_fail_horn_06.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_fail_horn_07.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_crashland_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_crashland_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_crashland_03.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_crashland_04.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_collide_close_up_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_collide_close_up_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_collide_close_up_03.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_collide_close_up_04.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_cat_sad_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_grapple_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_grapple_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_points_blip_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_grapple_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_grapple_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_music_ident_04.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_menu_click_01.mp3"));
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_cat_meow_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_cat_meow_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_collect_key_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_award_pop_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_award_pop_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_award_pop_03.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_teleport_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_points_blip_end_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_blow_arrow_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_blow_arrow_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_blow_arrow_03.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_pickup_good_01.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_pickup_good_02.mp3")); 
  loadTasks_.push(new SoundEffectLoadTask("kh_sfx_pickup_good_03.mp3"));
}

void GameLoadingScene::changeScene() {
  ScreenManager::activateGameScreen(chapter_, level_);
}