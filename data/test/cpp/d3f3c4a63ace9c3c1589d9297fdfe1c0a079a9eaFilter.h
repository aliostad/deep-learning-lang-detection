/*
 * Filter.h
 *
 *  Created on: Nov 11, 2013
 *      Author: georgebrindeiro
 */

#ifndef FILTER_H_
#define FILTER_H_

#include <Types/Typedefs.h>
#include <Types/State.h>

#include <Model/Motion/MotionModel.h>
#include <Model/Measurement/MeasurementModel.h>

class Filter
{
	public:

		Filter(State state, MotionModel motion_model, MeasurementModel measurement_model)
			: state_(state), motion_model_(motion_model), measurement_model_(measurement_model)
		{
		}

		// Use motion model to update state vector
		bool prediction_step(const nav_msgs::Odometry::ConstPtr& u_msg/*Vector u*/);

		// Use measurement model to update state vector
		bool correction_step(const sensor_msgs::PointCloud2::ConstPtr& z_msg/*Vector z*/);

		const State& state()
		{
			return state_;
		}

	private:

		State state_;
		MotionModel motion_model_;
		MeasurementModel measurement_model_;
};

#endif /* FILTER_H_ */
