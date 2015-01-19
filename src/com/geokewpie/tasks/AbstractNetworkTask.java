package com.geokewpie.tasks;

import android.content.Context;
import android.os.AsyncTask;
import android.widget.Toast;
import com.geokewpie.R;
import com.geokewpie.network.exception.NetworkException;

import java.net.ConnectException;
import java.util.concurrent.Callable;

public abstract class AbstractNetworkTask<Params, Progress, Result> extends AsyncTask<Params, Progress, Result> {
    private Context context;
    private String errorMessage;

    public AbstractNetworkTask(Context context) {
        this.context = context;
    }

    @Override
    protected Result doInBackground(Params... params) {
        try {
            return new NetworkCallable(params).call();
        } catch (NetworkException e) {
            errorMessage = context.getResources().getString(R.string.network_not_available);
            return null;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void onPostExecute(Result result) {
        super.onPostExecute(result);
        if (errorMessage != null) {
            Toast.makeText(context, errorMessage, Toast.LENGTH_LONG).show();
        }
    }

    public Context getContext() {
        return context;
    }

    protected abstract Result doNetworkOperation(Params[] params) throws Exception;

    private class NetworkCallable implements Callable {

        private final Params[] params;

        public NetworkCallable(Params[] params) {
            this.params = params;
        }

        @Override
        public Result call() throws Exception {
            return doNetworkOperation(params);
        }
    }
}
