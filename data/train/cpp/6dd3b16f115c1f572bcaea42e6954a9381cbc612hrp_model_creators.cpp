#include <iostream>

#include "hrp_model_creators.h"

#include "models_camera_height.h"
#include "models_threed_gyro.h"
#include "models_waist_velocity.h"
#include "models_orientation.h"
#include "models_wpg_motion.h"
#include "models_wpg_hybrid_motion.h"


#include <MonoSLAM/models_zeroorder.h>
#include <MonoSLAM/models_impulse.h>

#include <MonoSLAM/models_wideangle.h>


/** Returns an instance of the requested internal measurement model
    (using <code>new</code>). Returns NULL if there was no match.
**/
Internal_Measurement_Model* HRP_Internal_Measurement_Model_Creator::
create_model(const std::string& type, Motion_Model *motion_model)
{
  // Try creating each model that we can and see if the name is the same
  std::cout << "Creating a " << type << " internal measurement model"
            << std::endl;
  Internal_Measurement_Model* pModel;

  pModel = new
    Camera_Height_Internal_Measurement_Model(motion_model);
  if(pModel->internal_type == type)
    return pModel;
  else
    delete pModel;

  pModel = new
    ThreeD_Gyro_Internal_Measurement_Model(motion_model);
  if(pModel->internal_type == type)
    return pModel;
  else
    delete pModel;

  pModel = new
    Waist_Velocity_Internal_Measurement_Model(motion_model);
  if(pModel->internal_type == type)
    return pModel;
  else
    delete pModel;

  pModel = new Orientation_Internal_Measurement_Model(motion_model);
  if(pModel->internal_type == type)
    return pModel;
  else
    delete pModel;

  return NULL;
}

/** Returns an instance of the requested motion model (using
 <code>new</code>). Returns NULL if there was no match.
**/
Motion_Model* HRP2MonoSLAM_Motion_Model_Creator::create_model(const std::string& type)
{
  // Try creating each model that we can and see if the name is the same
  std::cout << "Creating a " << type << " motion model" << std::endl;
  Motion_Model* pModel;

  pModel = new ZeroOrder_ThreeD_Motion_Model;
  if(pModel->motion_model_type == type)
    return pModel;
  else
    delete pModel;

  pModel = new Impulse_ThreeD_Motion_Model;
  if(pModel->motion_model_type == type)
    return pModel;
  else
    delete pModel;

  pModel = new WPG_ThreeD_Motion_Model;
  if(pModel->motion_model_type == type)
    return pModel;
  else
    delete pModel;

  pModel = new WPG_Hybrid_ThreeD_Motion_Model;
  if(pModel->motion_model_type == type)
    return pModel;
  else
    delete pModel;

  return NULL;
}
