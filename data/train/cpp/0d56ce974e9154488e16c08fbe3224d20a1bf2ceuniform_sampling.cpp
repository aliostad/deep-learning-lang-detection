#include "manipulation_location_generator/uniform_sampling.h"
#include <tf/tf.h>

namespace manipulation_location_generator
{
	UniformSampling::UniformSampling(double sample_dist_table, double sample_angle_table, long int seed)
		: sample_dist_table_(sample_dist_table), sample_angle_table_(sample_angle_table)
	{
	    if(seed == 0)
	        srand48(time(NULL));
	    else
	        srand48(seed);
	}

	UniformSampling::~UniformSampling()
	{
	}

	geometry_msgs::Pose UniformSampling::generateSample()
	{
		geometry_msgs::Pose sample;

		double x, y;
		double sample_range_x = table_height_ + 2 * sample_dist_table_;
		double sample_range_y = table_width_ + 2 * sample_dist_table_;

		bool valid_sample = false;

		while (!valid_sample)
		{
			// value between [-(table_height_/2 + dist_table_edge); (table_height_/2 + dist_table_edge)]
			x = drand48() * sample_range_x - table_height_ / 2 - sample_dist_table_;

			// value between [-(table_width_/2 + dist_table_edge); (table_width_/2 + dist_table_edge)]
			y = drand48() * sample_range_y - table_width_ / 2 - sample_dist_table_;

			// check if sample is outside of table contour
			if (isSampleValid(x, y))
				valid_sample = true;
		}

		// adjust orientation to table center
		// center at (0, 0)
		double yaw = atan2(0 - y, 0 - x);
		double sample_range = sample_angle_table_;
		// value between [-pi/2, pi/2]
		double noise = drand48() * sample_range - sample_angle_table_/2;
		yaw = yaw + noise;
		tf::Quaternion q = tf::createQuaternionFromYaw(yaw);
		geometry_msgs::Quaternion orientation;
		tf::quaternionTFToMsg(q, orientation);

		sample.position.x = x;
		sample.position.y = y;
		sample.position.z = 0;
		sample.orientation = orientation;

		return sample;
	}

	bool UniformSampling::isSampleValid(const double& x, const double& y)
	{
		if (fabs(x) <= table_height_/2 && fabs(y) <= table_width_/2)
			return false;
		else
			return true;
	}

};
