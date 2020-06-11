#include "opencv2/core/core.hpp"
#include <Camera/CameraModel.h>

int main(){
  using cv::FileStorage;
  {
    FileStorage fs("test_camera_model_1.yml", FileStorage::WRITE);
    Camera::CameraModel testModel(1,2,3,4,5,6,7);
    fs << "camera_model" << testModel;
  }
  {
    FileStorage fs("test_camera_model_1.yml", FileStorage::READ);
    Camera::CameraModel testModel=Camera::CameraModel::readFrom(fs["camera_model"]);
    FileStorage fs2("test_camera_model_2.yml", FileStorage::WRITE);
    fs2 << "theCameraModel" << testModel;
  }
  return 0;
}
