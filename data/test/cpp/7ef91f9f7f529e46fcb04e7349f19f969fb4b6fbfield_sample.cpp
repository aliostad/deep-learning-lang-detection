#include "field_sample.hpp"
#include "utils.hpp"

field_sample::field_sample(nsecs_t timestamp)
: timestamp(timestamp)
, ball_set(false)
{
}
field_sample::~field_sample()
{
}
void field_sample::add_robot (bot_sample sample)
{
        robots.insert(std::make_pair(sample.get_id(), sample));
}
void field_sample::add_ball (ball_sample sample)
{
        this->ball = sample;
        this->ball_set = true;
}

bool field_sample::get_robot(e_robot id, const bot_sample* &sample) const
{
        if (robots.count(id) != 0) {
                sample = &robots.at(id);
                return true;
        }
                return false;
}

bool field_sample::get_ball (const ball_sample* &sample) const
{
        if (ball_set)
                sample = &this->ball;
        return ball_set;
}

int field_sample::get_sampled_bots_count() const
{
        return (int)robots.size();
}

bool field_sample::get_bot_sampled(e_robot rid) const
{
        return robots.count(rid) != 0;
}

bool field_sample::get_ball_sampled() const
{
        return ball_set;
}

nsecs_t field_sample::get_timestamp() const
{
        return this->timestamp;
}
