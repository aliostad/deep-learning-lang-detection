#include "StdAfx.h"
#include "ObserveGoal.h"

MCLSample* ObserveGoal::sample;
bool ObserveGoal::sample_set = false;

ObserveGoal::ObserveGoal()
{
}

void
ObserveGoal::SetSample(MCLSample* input)
{
	sample = input;
	sample_set = true;
}

void
ObserveGoal::Observation(GoalInformation _input)
{
	if(!sample_set) return;

	int pixels = state.self.cdt[_input.goal_color_id].value;
	//OSYSPRINT(("Observe Goal %d %f %f %d \n",_input.goal_color_id,_input.directionLeft,_input.directionRight,sample));
	
	DirectionOfGoal(_input.goal_color_id,_input.directionRight,_input.directionLeft);
	
	double sum = 0.0;
	for(int i=0;i<SAMPLE_NUMBER;i++)
		sum += sample->sample[i].m_w;

	if(sum < 0.02)
		sample->ExpansionResetting();
	else
	{
		for(int i=0;i<SAMPLE_NUMBER;i++)	
			sample->sample[i].m_w /= sum;
	}
	state.self.position = sample->CalcAverageAndStdDev();
}

void
ObserveGoal::DirectionOfGoal(COLOR_NAME_TAG color,double direction0,double direction1)
{
//direction////////////////////////////////////////////////////////////////
	double thr;
	
	thr = PI/12.0;
	double direction_rad0 = direction0*3.141592/180.0;
	double direction_rad1 = direction1*3.141592/180.0;

	double x,y,th1,th2;
	if(color == SKYBLUE)
	{
		int harf_goal_width = GOAL_WIDTH/2;
		for(int t=0;t<SAMPLE_NUMBER;t++)
		{
			sample->sample[t].m_t &= MCLSample::m_nSinCosMask;
			unsigned int a = sample->sample[t].m_t;
			if(sample->sample[t].m_x < -FIELD_MAX_X && abs(sample->sample[t].m_y) > GOAL_WIDTH)//ƒS[ƒ‹ŠO
			{
				sample->sample[t].m_w *= 0.0001;
				continue;
			}

			double goal_x = -FIELD_MAX_X - sample->sample[t].m_x;
			double goal_y0 = -harf_goal_width - sample->sample[t].m_y;
			double goal_y1 = harf_goal_width - sample->sample[t].m_y;
			
			x = goal_x*MCLSample::m_dCos[a] + goal_y0*MCLSample::m_dSin[a];
			y = -goal_x*MCLSample::m_dSin[a] + goal_y0*MCLSample::m_dCos[a];
			th1 = atan2(y,x);
			x = goal_x*MCLSample::m_dCos[a] + goal_y1*MCLSample::m_dSin[a];
			y = -goal_x*MCLSample::m_dSin[a] + goal_y1*MCLSample::m_dCos[a];
			th2 = atan2(y,x);

			if(sample->sample[t].m_x > -FIELD_MAX_X)
			{
				if(th1 + thr < direction_rad0 || th2 - thr > direction_rad0)
				{
					sample->sample[t].m_w *= 0.0001;
				}
				if(th1 + thr < direction_rad1 || th2 - thr > direction_rad1)
				{
					sample->sample[t].m_w *= 0.0001;
				}
			}
			else
			{
				if(th1 > 0 && th2 < 0)
				{
					if(th1 + thr < direction_rad0 || th2 - thr > direction_rad0)
					{
						sample->sample[t].m_w *= 0.0001;
					}
					if(th1 + thr < direction_rad1 || th2 - thr > direction_rad1)
					{
						sample->sample[t].m_w *= 0.0001;
					}
				}
				else if(th1 < 0)
				{
					if(th2 - thr > direction_rad0)
					{
						sample->sample[t].m_w *= 0.0001;
					}
					if(th2 - thr > direction_rad1)
					{
						sample->sample[t].m_w *= 0.0001;
					}
				}
				else if(th2 > 0)
				{
					if(th1 + thr < direction_rad0)
					{
						sample->sample[t].m_w *= 0.0001;
					}
					if(th1 + thr < direction_rad1)
					{
						sample->sample[t].m_w *= 0.0001;
					}
				}
			}
		}
	}
	else//yellow
	{
		int harf_goal_width = GOAL_WIDTH/2;
		for(int t=0;t<SAMPLE_NUMBER;t++)
		{
			sample->sample[t].m_t &= MCLSample::m_nSinCosMask;
			unsigned int a = sample->sample[t].m_t;
			if(sample->sample[t].m_x > FIELD_MAX_X && abs(sample->sample[t].m_y) > GOAL_WIDTH)//ƒS[ƒ‹ŠO
			{
				sample->sample[t].m_w *= 0.0001;
				continue;
			}

			double goal_x = FIELD_MAX_X - sample->sample[t].m_x;
			double goal_y0 = harf_goal_width - sample->sample[t].m_y;
			double goal_y1 = -harf_goal_width - sample->sample[t].m_y;
			
			x = goal_x*MCLSample::m_dCos[a] + goal_y0*MCLSample::m_dSin[a];
			y = -goal_x*MCLSample::m_dSin[a] + goal_y0*MCLSample::m_dCos[a];
			th1 = atan2(y,x);
			x = goal_x*MCLSample::m_dCos[a] + goal_y1*MCLSample::m_dSin[a];
			y = -goal_x*MCLSample::m_dSin[a] + goal_y1*MCLSample::m_dCos[a];
			th2 = atan2(y,x);

			if(sample->sample[t].m_x < FIELD_MAX_X)
			{
				if(th1 + thr < direction_rad0 || th2 - thr > direction_rad0)
				{
					sample->sample[t].m_w *= 0.0001;
				}
				if(th1 + thr < direction_rad1 || th2 - thr > direction_rad1)
				{
					sample->sample[t].m_w *= 0.0001;
				}
			}
			else
			{
				if(th1 > 0 && th2 < 0)
				{
					if(th1 + thr < direction_rad0 || th2 - thr > direction_rad0)
					{
						sample->sample[t].m_w *= 0.0001;
					}
					if(th1 + thr < direction_rad1 || th2 - thr > direction_rad1)
					{
						sample->sample[t].m_w *= 0.0001;
					}
				}
				else if(th1 < 0)
				{
					if(th2 - thr > direction_rad0)
					{
						sample->sample[t].m_w *= 0.0001;
					}
					if(th2 - thr > direction_rad1)
					{
						sample->sample[t].m_w *= 0.0001;
					}
				}
				else if(th2 > 0)
				{
					if(th1 + thr < direction_rad0)
					{
						sample->sample[t].m_w *= 0.0001;
					}
					if(th1 + thr < direction_rad1)
					{
						sample->sample[t].m_w *= 0.0001;
					}
				}
			}
		}
	}
	//OSYSPRINT(("End ObserveGoal::DirectionOfGoal()\n"));
}

