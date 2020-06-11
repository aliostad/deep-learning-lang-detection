package com.iboxpay.wallet.urihandler;

import android.app.Application;

import com.iboxpay.wallet.kits.core.modules.ModuleHandlerStore;
import com.iboxpay.wallet.kits.core.modules.UriDispatcherHandler;

/**
 * Created by wangxiunian on 2016/8/13.
 */
public class AppModuleHandlerStore extends ModuleHandlerStore {

    public AppModuleHandlerStore(Application application) {
        super(application);
    }

    @SuppressWarnings("unchecked")
    @Override
    protected <T extends UriDispatcherHandler> Class<T>[] registHandlers() {
        Class<T>[] clazzes = new Class[]{
                LoginHandler.class,
                WalletHttpHandler.class,
                AccessTokenHandler.class,
                BankCardAddHandler.class,//
                UserProfileHandler.class,
                BankCardManagerHandler.class,
                RechargeHandler.class,
                LocationGetHandler.class,
                ImageChoiceHandler.class,
                CheckLivenessHandler.class,
                RichScanHandler.class,
                PaymentCodeHandler.class,
//                OCRCallHandler.class,
                RunTimeHandler.class,
                ContactGetHandler.class,
                TopUpHandler.class,
                VerifyPayPasswordHandler.class,
                UserIdentifyHandler.class,
                ShowNativeLoadingHandler.class,
                ToastHandler.class,
                SysRuntimeProxyHandler.class,
                MyQrcodeHandler.class,
                ShareHandler.class,
                WalletHttpHandlerTemp.class,
                AlertDialogHandler.class,
                ProgressDialogHandler.class,
                AreaSelectHandler.class,
                BankBranchHandler.class,
                CashboxHttpHandler.class,
                GetAddressBookHandler.class,
                OpenAddressHandler.class,
                GetAllDeviceInfoHandler.class,
                UploadBqsHandler.class,
                GetAllDeviceInfoHandler.class,
                BalanceHandler.class
        };
        return clazzes;

    }
}
