package com.geokewpie.activities;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.widget.Toolbar;
import android.widget.ListView;
import com.geokewpie.CallableWithArguments;
import com.geokewpie.R;
import com.geokewpie.beans.User;
import com.geokewpie.content.Properties;
import com.geokewpie.followers.FollowerAdapter;
import com.geokewpie.tasks.GetFollowersTask;

import java.util.List;

public class FollowersActivity extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.followers);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        GetFollowersTask followersTask = new GetFollowersTask(getApplicationContext(), new CallableWithArguments<Void, List<User>>() {
            @Override
            public Void call(List<User> users) throws Exception {
                ListView followersList = (ListView) findViewById(R.id.followers_lv);
                followersList.setAdapter(new FollowerAdapter(getApplicationContext(), users));
                return null;
            }
        });

        SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());

        String email = settings.getString(Properties.EMAIL, "");
        String authToken = settings.getString(Properties.AUTH_TOKEN, "");

        followersTask.execute(email, authToken);
    }
}
