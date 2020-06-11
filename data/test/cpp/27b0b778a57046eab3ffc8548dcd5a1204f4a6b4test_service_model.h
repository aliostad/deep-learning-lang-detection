#ifndef _SERVICE_MODEL_H_
#define _SERVICE_MODEL_H_

#include <dee.h>
#include <UnityCore/GLibWrapper.h>
#include <UnityCore/GLibSource.h>

namespace unity
{
namespace service
{

class Model
{
public:
  Model();

private:
  void PopulateTestModel();
  void PopulateResultsModel();
  void PopulateCategoriesModel();
  void PopulateCategoriesChangesModel();
  void PopulateTracksModel();

  bool OnCategoryChangeTimeout();
  bool OnTrackChangeTimeout();

private:
  glib::Object<DeeModel> model_;
  glib::Object<DeeModel> results_model_;
  glib::Object<DeeModel> categories_model_;
  glib::Object<DeeModel> categories_changing_model_;
  glib::Object<DeeModel> tracks_model_;

  glib::Source::Ptr category_timeout_;
  glib::Source::Ptr track_timeout_;
};

}
}

#endif /* _SERVICE_MODEL_H_ */
