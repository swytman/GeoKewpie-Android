package com.geokewpie.add;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.view.*;
import android.widget.*;
import com.geokewpie.CallableWithArguments;
import com.geokewpie.R;
import com.geokewpie.content.Properties;
import com.geokewpie.network.Response;
import com.geokewpie.tasks.SendRequestTask;

import java.util.List;

public class SearchResultsAdapter extends ArrayAdapter<SearchResultsModel> {
    private Context context;
    private List<SearchResultsModel> views;

    private String authToken;
    private String email;

    public SearchResultsAdapter(Context context, List<SearchResultsModel> views) {
        super(context, R.layout.search_result_item, views);

        this.context = context;
        this.views = views;

        SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(context);
        authToken = settings.getString(Properties.AUTH_TOKEN, "");
        email = settings.getString(Properties.EMAIL, "");
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View rowView = inflater.inflate(R.layout.search_result_item, parent, false);
        TextView titleView = (TextView) rowView.findViewById(R.id.search_result_text);
        Button button = (Button) rowView.findViewById(R.id.search_result_add);

        SearchResultsModel searchResultsModel = views.get(position);

        final String login = searchResultsModel.getTitle();
        titleView.setText(login);

        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                SendRequestTask srt = new SendRequestTask(context, new CallableWithArguments<Void, Response>() {
                    @Override
                    public Void call(Response response) throws Exception {
                        Toast.makeText(context, context.getResources().getString(R.string.request_sent), Toast.LENGTH_LONG).show();
                        return null;
                    }
                });
                srt.execute(login, email, authToken);
            }
        });

        return rowView;
    }

    @Override
    public boolean areAllItemsEnabled() {
        return false;
    }
}
