package com.geokewpie.activities;

import android.app.Activity;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;
import com.geokewpie.Properties;
import com.geokewpie.R;
import com.geokewpie.network.Response;
import com.geokewpie.tasks.SendRequestTask;

public class AddActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add);
    }

    public void sendRequest(View view) throws Exception {
        SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
        String authToken = settings.getString(Properties.AUTH_TOKEN, "");
        String email = settings.getString(Properties.EMAIL, "");

        EditText user = (EditText) findViewById(R.id.user_to_add);

        SendRequestTask srt = new SendRequestTask();
        srt.execute(user.getText().toString(), email, authToken);
        Response response = srt.get();

        if (response.isSuccessful()) {
            Toast.makeText(getApplicationContext(), getResources().getString(R.string.request_sent), Toast.LENGTH_LONG).show();
        } else {
            Toast.makeText(getApplicationContext(), getResources().getString(R.string.retry_later), Toast.LENGTH_LONG).show();
        }
    }
}
