package com.aspirephile.shared.ui.error;

import android.support.v4.app.FragmentManager;
import android.support.v7.app.AppCompatActivity;
import android.view.View;

import com.aspirephile.shared.debug.Logger;
import com.aspirephile.shared.debug.NullPointerAsserter;
import com.aspirephile.shared.ui.BuildConfig;

public class ProcessErrorActivity extends AppCompatActivity {
    private Logger l = new Logger(ProcessErrorActivity.class);
    private NullPointerAsserter asserter = new NullPointerAsserter(l);

    private ProcessErrorFragment processErrorF = null;
    private String processErrorTag = null;
    private int processErrorContainerId = 0;

    public boolean isProcessErrorFragmentOpened() {
        return processErrorF != null;
    }

    protected void openProcessErrorFragment() {
        l.d("Opening process error fragment");
        asserter.assertPointer(processErrorTag);
        if (processErrorContainerId == 0)
            l.e("Attempting to open process error fragment without setting process error container ID!");
        FragmentManager fm = getSupportFragmentManager();
        processErrorF = (ProcessErrorFragment) fm.findFragmentByTag(processErrorTag);

        if (!asserter.assertPointerQuietly(processErrorF)) {
            l.i("Creating new " + ProcessErrorFragment.class.getSimpleName() + " fragment");
            processErrorF = new ProcessErrorFragment();
            fm.beginTransaction()
                    .replace(processErrorContainerId, processErrorF, processErrorTag)
                    .commit();
        }
        asserter.assertPointer(processErrorF);
    }

    public void setProcessErrorParentContentView(View processErrorParentContentView) {
        if (asserter.assertPointer(processErrorF))
            this.processErrorF.setParentContentView(processErrorParentContentView);
    }

    protected void setProcessErrorTag(String processErrorTag) {
        this.processErrorTag = processErrorTag;
    }

    protected void setProcessErrorContainerId(int processErrorContainerId) {
        this.processErrorContainerId = processErrorContainerId;
    }

    @SuppressWarnings("unused")
    public void attachProcessErrorManager(ProcessErrorManager errorManager) {
        if (!asserter.assertPointerQuietly(processErrorF))
            openProcessErrorFragment();
        processErrorF.attachOnProcessErrorManager(errorManager);
    }

    @SuppressWarnings("unused")
    public void detachProcessErrorManager(ProcessErrorManager errorManager) {
        if (!asserter.assertPointerQuietly(processErrorF))
            openProcessErrorFragment();
        processErrorF.detachProcessErrorManager(errorManager);
    }

}