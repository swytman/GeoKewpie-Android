package com.geokewpie.followers;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.view.*;
import android.widget.*;
import com.geokewpie.CallableWithArguments;
import com.geokewpie.R;
import com.geokewpie.beans.User;
import com.geokewpie.content.Properties;
import com.geokewpie.tasks.AcceptDeleteFollowerTask;

import java.util.List;

public class FollowerAdapter extends ArrayAdapter<User> {
    private Context context;
    private List<User> users;

    public FollowerAdapter(Context context, List<User> users) {
        super(context, R.layout.search_result_item, users);

        this.context = context;
        this.users = users;
    }

    @Override
    public View getView(int position, View convertView, final ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(context);

        final String email = settings.getString(Properties.EMAIL, "");
        final String authToken = settings.getString(Properties.AUTH_TOKEN, "");

        final User user = users.get(position);
        final String login = user.getLogin();

        final View rowView = inflater.inflate(R.layout.follower_item, parent, false);

        TextView loginView = (TextView) rowView.findViewById(R.id.follower_login);
        final Button acceptButton = (Button) rowView.findViewById(R.id.follower_accept_btn);
        Button deleteButton = (Button) rowView.findViewById(R.id.follower_delete_btn);

        loginView.setText(login);
        if ("active".equalsIgnoreCase(user.getStatus())) {
            acceptButton.setVisibility(View.INVISIBLE);
        } else {
            deleteButton.setText(context.getResources().getString(R.string.decline));

            acceptButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    new AcceptDeleteFollowerTask(context, new CallableWithArguments<Void, Void>() {
                        @Override
                        public Void call(Void aVoid) throws Exception {
                            return null;
                        }
                    }).execute(login, email, authToken, "POST");
                    acceptButton.setVisibility(View.INVISIBLE);
                }
            });
        }

        deleteButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                new AcceptDeleteFollowerTask(context, new CallableWithArguments<Void, Void>() {
                    @Override
                    public Void call(Void aVoid) throws Exception {
                        return null;
                    }
                }).execute(login, email, authToken, "DELETE");

                remove(user);
                notifyDataSetChanged();
            }
        });

        return rowView;
    }

}
