package com.geokewpie.activities;

import android.app.SearchManager;
import android.content.*;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.widget.SearchView;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.widget.ListView;
import com.geokewpie.CallableWithArguments;
import com.geokewpie.R;
import com.geokewpie.add.SearchResultsAdapter;
import com.geokewpie.add.SearchResultsModel;
import com.geokewpie.beans.User;
import com.geokewpie.content.Properties;
import com.geokewpie.tasks.SearchKewpiesTask;

import java.util.ArrayList;
import java.util.List;

public class AddActivity extends ActionBarActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        handleIntent(getIntent());
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.options_menu, menu);

        // Associate searchable configuration with the SearchView
        SearchManager searchManager =
                (SearchManager) getSystemService(Context.SEARCH_SERVICE);
        SearchView searchView =
                (SearchView) menu.findItem(R.id.search_kewpie).getActionView();
        searchView.setSearchableInfo(
                searchManager.getSearchableInfo(getComponentName()));

        searchView.setIconified(false);

        return true;
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        handleIntent(intent);
    }

    private void handleIntent(Intent intent) {
        System.out.println("!!!!!!!!!!!!!!!!!!!! " + intent.getAction());
        if (Intent.ACTION_SEARCH.equals(intent.getAction())) {
            String query = intent.getStringExtra(SearchManager.QUERY);

            updateSearchResults(query);
        }
    }

    private void updateSearchResults(String query) {
        SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());

        String email = settings.getString(Properties.EMAIL, "");
        String authToken = settings.getString(Properties.AUTH_TOKEN, "");

        SearchKewpiesTask task = new SearchKewpiesTask(getApplicationContext(), new CallableWithArguments<Void, List<User>>() {
            @Override
            public Void call(List<User> users) throws Exception {
                List<SearchResultsModel> views = new ArrayList<SearchResultsModel>();
                for (User user : users) {
                    views.add(new SearchResultsModel(user.getLogin()));
                }

                if (views.isEmpty()) {
                    views.add(new SearchResultsModel(getApplicationContext().getString(R.string.nobody_found)));
                }

                SearchResultsAdapter adapter = new SearchResultsAdapter(getApplicationContext(), views);

                ListView searchResultsView = (ListView) findViewById(R.id.kewpies_search_results);
                searchResultsView.setAdapter(adapter);

                return null;
            }
        });

        task.execute(query, email, authToken);
    }
}
