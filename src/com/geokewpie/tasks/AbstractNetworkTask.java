package com.geokewpie.tasks;

import android.content.Context;
import android.os.AsyncTask;
import android.widget.Toast;
import com.geokewpie.CallableWithArguments;
import com.geokewpie.R;
import com.geokewpie.beans.User;
import com.geokewpie.network.exception.NetworkException;

import java.util.List;

public abstract class AbstractNetworkTask<Params, Progress, Result> extends AsyncTask<Params, Progress, Result> {
    protected Context context;
    protected String errorMessage;
    private CallableWithArguments<Void, Result> callable;

    public AbstractNetworkTask(Context context) {
        this.context = context;
    }

    public AbstractNetworkTask(Context context, CallableWithArguments<Void, Result> callable) {
        this.context = context;
        this.callable = callable;
    }

    @Override
    protected Result doInBackground(Params... params) {
        try {
            System.out.println("ALBA AbstractNetworkTask.doInBackground 0");
            return doNetworkOperation(params);
        } catch (NetworkException e) {
            System.out.println("ALBA AbstractNetworkTask.doInBackground 1");
            errorMessage = context.getResources().getString(R.string.network_not_available);
            return null;
        } catch (Exception e) {
            System.out.println("ALBA AbstractNetworkTask.doInBackground 2");
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void onPostExecute(Result result) {
        super.onPostExecute(result);
        if (errorMessage != null) {
            Toast.makeText(context, errorMessage, Toast.LENGTH_LONG).show();
        } else if (callable != null) {
            try {
                callable.call(result);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }
    }

    protected abstract Result doNetworkOperation(Params[] params) throws Exception;
}