#include "Model.h"

Model::Model()
{

}

Model::~Model()
{

}

int Model::Choose_Model_Type(Model_Para *model_para,LogFile* logFile){

    if (model_para->model_status == MODEL_STATUS_UNKNOWN) {
        cout<<"Please specify the task you would like to perform (est/inf)!\n";
        return 1;
    }

    if (model_para->model_type == MODEL_NAME_UNKNOWN) {
        cout<<"Please specify the model you would like to perform (LDA / JST / USTM_FT_W / SENLDA / ASUM)!\n";
        return 1;
    }

    if (model_para->model_type == MODEL_NAME_LDA){
        LDA_process(model_para,logFile);
        return 0;
    }

    else if (model_para->model_type == MODEL_NAME_JST & model_para->model_status == MODEL_STATUS_EST){
        JST_Train(model_para,logFile);
        return 0;
    }

    else if (model_para->model_type == MODEL_NAME_JST & model_para->model_status == MODEL_STATUS_INF){
        JST_Test(model_para,logFile);
        return 0;
    }

    else if (model_para->model_type == MODEL_NAME_USTM_FW_W){
        USTM_FT_W_process(model_para,logFile);
        return 0;
    }

    else if (model_para->model_type == MODEL_NAME_D_PLDA){
        D_PLDA_process(model_para,logFile);
        return 0;
    }

    else if (model_para->model_type == MODEL_NAME_SENLDA & model_para->model_status == MODEL_STATUS_EST){
        SENLDA_Train(model_para,logFile);
        return 0;
    }

    else if (model_para->model_type == MODEL_NAME_SENLDA & model_para->model_status == MODEL_STATUS_INF){
        SENLDA_Test(model_para,logFile);
        return 0;
    }

    else if (model_para->model_type == MODEL_NAME_ASUM & model_para->model_status == MODEL_STATUS_EST){
        ASUM_Train(model_para,logFile);
        return 0;
    }

    else if (model_para->model_type == MODEL_NAME_ASUM & model_para->model_status == MODEL_STATUS_INF){
        ASUM_Test(model_para,logFile);
        return 0;
    }

}

int Model::LDA_process(Model_Para *model_para,LogFile* logFile){
    LDA lda;
    lda.set_log_file(logFile);
    lda.excute_model(model_para);
}

int Model::JST_Train(Model_Para *model_para,LogFile* logFile){
    JST_model jst_est;
    jst_est.set_log_file(logFile);
    jst_est.excute_model(model_para);
}

int Model::JST_Test(Model_Para *model_para,LogFile* logFile){
    JST_inference jst_inf;
    jst_inf.set_log_file(logFile);
    jst_inf.excute_model(model_para);
}

int Model::USTM_FT_W_process(Model_Para *model_para,LogFile* logFile){
    USTM_FT_W ustm_ft_w;
    ustm_ft_w.set_log_file(logFile);
    ustm_ft_w.excute_model(model_para);
}

int Model::D_PLDA_process(Model_Para *model_para,LogFile* logFile){
    D_PLDA d_plda;
    d_plda.set_log_file(logFile);
    d_plda.excute_model(model_para);
}


int Model::SENLDA_Train(Model_Para *model_para,LogFile* logFile){
    SenLDA_model senLda_est;
    senLda_est.set_log_file(logFile);
    senLda_est.excute_model(model_para);
}

int Model::SENLDA_Test(Model_Para *model_para,LogFile* logFile){


}

int Model::ASUM_Train(Model_Para *model_para,LogFile* logFile){
    ASUM_model asum_est;
    asum_est.set_log_file(logFile);
    asum_est.excute_model(model_para);
}

int Model::ASUM_Test(Model_Para *model_para,LogFile* logFile){


}



