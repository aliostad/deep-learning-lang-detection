#include "ros/ros.h"
#include "std_msgs/String.h"
#include "gazebo/ModelStates.h"

using namespace std;

class SaveModelStates{
public:
	SaveModelStates(string ModelName);
	~SaveModelStates();
private:
	ros::NodeHandle nh;
	
	ros::Subscriber modelStates_sub_;
	
	string modelName;
	FILE * f;

	void ReceiveModelStates(const gazebo::ModelStates& modelState);
};

SaveModelStates::SaveModelStates(string ModelName){
	string fileName = "record/" + ModelName + ".log";
	f = fopen(fileName.c_str(),"w");
	modelName = ModelName;
	modelStates_sub_ = nh.subscribe("gazebo/model_states",1,&SaveModelStates::ReceiveModelStates,this);
}
SaveModelStates::~SaveModelStates(){
	fclose(f);
}
void SaveModelStates::ReceiveModelStates(const gazebo::ModelStates& modelStates)
{
	for(unsigned int i=0;i<modelStates.name.size();i++)
	{
		if(modelStates.name[i]==modelName)
		{
			ROS_INFO("Name %s", modelStates.name[i].c_str());
			ROS_INFO("Pose %lf %lf %lf", modelStates.pose[i].position.x, modelStates.pose[i].position.y, modelStates.pose[i].position.z);
			fprintf(f,"%lf %lf %lf\n", modelStates.pose[i].position.x, modelStates.pose[i].position.y, modelStates.pose[i].position.z);
			break;
		}
	}	
}

int main(int argc, char** argv)
{
	ros::init(argc, argv, "save_gazebo_model_states");
	ROS_INFO("SaveModelStates Started\n");
	SaveModelStates sms("small_ball_red");
	ros::spin();
	return 0;
}
