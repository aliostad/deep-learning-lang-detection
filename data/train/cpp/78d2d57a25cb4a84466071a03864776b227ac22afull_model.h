/**
 * Mark Benjamin 31st May 2017
 */

#ifndef FASTRL_MDP_SINGLEAGENT_MODEL_FULL_MODEL_HPP
#define FASTRL_MDP_SINGLEAGENT_MODEL_FULL_MODEL_HPP

#include "sample_model.hpp"
#include "transition_prob.hpp"

class FullModel : virtual public SampleModel {
public:
    virtual vector<TransitionProb *> transitions(State * s, Action * a) { throw "Not Implemented"; }
};

class FullModelHelper {
    static vector<TransitionProb *> deterministicTransition(SampleModel * model, State * s, Action * a);
    static EnvironmentOutcome * sampleByEnumeration(FullModel * model, State * s, Action * a);
};
#endif // FASTRL_MDP_SINGLEAGENT_MODEL_FULL_MODEL_HPP