package com.karazam.huashanapp.manage.details_fragment.view;

import com.example.utils.base.BaseView;
import com.karazam.huashanapp.manage.details_fragment.model.databinding.Opinions;
import com.karazam.huashanapp.manage.details_fragment.model.databinding.RecordsItem;

import java.util.ArrayList;

/**
 * Created by Administrator on 2016/11/10.
 */

public interface DetailsFragment2View extends BaseView{
    void setCurrentItem(int position);
                //getManageRecords
    void getManageRecordsSuccess(ArrayList<RecordsItem> records);

    void getManageRecordsFaile(String e);

    void getManageRecordsError(Throwable e);

                //getManageOpinions
    void getManageOpinionsSuccess(Opinions opinions);

    void getManageOpinionsFaile(String e);

    void getManageOpinionsError(Throwable e);
}
