#include "rcpp_maintenance_model.h"

using namespace Rcpp ;

//Forward declarations
//class VamModel;
//class MaintenanceModel;
//MaintenanceModel* newMaintenanceModel(List model,VamModel* model);

//Effective declarations
MaintenanceModelList::MaintenanceModelList(List models_,VamModel* model) {
    int i=0;
    for(
        List::iterator lit=models_.begin();
        lit != models_.end();
        ++lit
    ) {
    	List maintenance=*lit;
    	MaintenanceModel*  vam=newMaintenanceModel(maintenance,model);
        vam->set_id(i++);
        model_list.push_back(vam);
    }
}

MaintenanceModelList::~MaintenanceModelList() {
	for(
		std::vector<MaintenanceModel*>::iterator vit=model_list.begin();
		vit != model_list.end();
        ++vit
    ) {
		delete *vit;
	}

}

void ARA1::update(bool with_gradient) {
    /*# next step
    obj$vam$model$k <- obj$vam$model$k + 1
    # At T(k)
    obj$vam$model$Vright <- obj$vam$model$Vright + (1-obj$rho)*(dVlr <-(obj$vam$model$Vleft-obj$vam$model$Vright))
    if(with.gradient) {
        # only the rho parameters
        #obj$vam$model$dVright <- obj$vam$model$dVright + rep(0,1+length(obj$vam$vam.PM$models))
        i <- match(obj$id,seq(obj$vam$vam.PM$models),nomatch=0)+1
        obj$vam$model$dVright[i] <- obj$vam$model$dVright[i] - dVlr
    }
    # save old model
    obj$model$mod <- obj
    */
    model->k += 1;
    double dVlr = model->Vleft- model->Vright;
    model->Vright += (1-rho) * dVlr;
    if(with_gradient) {
        model->dVright[id] += -dVlr;
    }
    model->idMod = id;
}

double ARA1::virtual_age(double time) {
    //max(0.0000001,obj$vam$model$Vright+time-obj$vam$data$Time[obj$vam$model$k])
    //printf("virtual_age:%lf,%lf,%lf\n",model -> Vright, time,model->time[model->k]);
    return model -> Vright + time  - model->time[model->k];
}

double* ARA1::virtual_age_derivative(double x) {
    return model->dVright;
}

double ARA1::virtual_age_inverse(double time) {
    return time+model->time[model->k] - model->Vright;
}

void ARAInf::update(bool with_gradient) {
    model->k += 1;
    model->Vright = (1-rho) * model->Vleft;
    if(with_gradient) {
        for(int i=0;i<model->nbPM+1;i++) {
            model->dVright[i] = (1-rho) * model->dVright[i];
        }
        model->dVright[id] = model->dVright[id] - model->Vleft;
    }
    // save old model
    model->idMod = id;
}

double ARAInf::virtual_age(double time) {
    //max(0.0000001,obj$vam$model$Vright+time-obj$vam$data$Time[obj$vam$model$k])
    return model -> Vright + time  - model->time[model->k];
}

double* ARAInf::virtual_age_derivative(double x) {
    return model->dVright;
}

double ARAInf::virtual_age_inverse(double time) {
    return time+model->time[model->k] - model->Vright;
}


MaintenanceModel* newMaintenanceModel(List maintenance,VamModel* model) {
	std::string name=maintenance["name"];
	NumericVector params=maintenance["params"];
	MaintenanceModel*  mm=NULL;
	if(name.compare("ARA1.va.model") == 0) {
		double rho=params[0];
		mm=new ARA1(rho,model);
	} else if(name.compare("ARAInf.va.model") == 0) {
		double rho=params[0];
		mm=new ARAInf(rho,model);
	}
	return mm;
}
