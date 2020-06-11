#ifndef RCPP_SIM_VAM_H
#define RCPP_SIM_VAM_H
#include <Rcpp.h>
#include "rcpp_maintenance_model.h"

using namespace Rcpp ;

class SimVam { 

public:

    SimVam(List model_) {
        model=new VamModel(model_);
    };

    ~SimVam() {
        delete model;
    };

    DataFrame get_data() {
        return DataFrame::create(_["Time"]=model->time,_["Type"]=model->type);
    }

    DataFrame simulate(int nbsim) {
        init(nbsim);

        while(model->k < nbsim) {
            //### modAV <- if(Type[k]<0) obj$vam.CM[[1]]$model else obj$vam.PM$models[[obj$data$Type[k]]]
            //# Here, obj$model$k means k-1
            //#print(c(obj$model$Vleft,obj$model$Vright))
            double timePM, timeCM = model->models->at(model->idMod)->virtual_age_inverse(model->family->inverse_cumulative_density(model->family->cumulative_density(model->models->at(model->idMod)->virtual_age(model->time[model->k]))-log(runif(1))[0]));
            int idMod;
            List timeAndTypePM;
            if(model->maintenance_policy != NULL) {
                timeAndTypePM = model->maintenance_policy->update(model->time[model->k]); //# Peut-être ajout Vright comme argument de update
                
                NumericVector tmp=timeAndTypePM["time"];
                timePM=tmp[0];
            }
            if(model->maintenance_policy == NULL || timeCM < timePM) {
                model->time[model->k + 1]=timeCM;
                model->type[model->k + 1]=-1;
                idMod=0;
            } else {
                model->time[model->k + 1]=timePM;
                NumericVector tmp2=timeAndTypePM["type"];
                int typePM=tmp2[0];
                model->type[model->k + 1]=typePM;
                idMod=timeAndTypePM["type"];
            }
            //# used in the next update
            model->update_Vleft(false);
            //# update the next k, and save model in model too!
            model->models->at(idMod)->update(false);
        }

        return get_data();
    }

    VamModel* get_model() {
        return model;
    }

    NumericVector get_params() {
        return model->get_params();
    }

    void set_params(NumericVector pars) {
        model->set_params(pars);
    }

    //delegate from model cache!
    List get_virtual_age_infos(double by) {
        return model->get_virtual_age_infos(by);
    }


private:
    VamModel* model;

    void init(int nbsim) {
        model->Vright=0;
        model->k=0;
        model->idMod=0; // Since no maintenance is possible!
        model->time=rep(0,nbsim+1);
        model->type= rep(1,nbsim+1);
    } 

};

#endif //RCPP_SIM_VAM_H