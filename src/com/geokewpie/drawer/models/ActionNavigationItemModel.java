package com.geokewpie.drawer.models;

import android.view.*;
import android.widget.ImageView;
import android.widget.TextView;
import com.geokewpie.R;

public class ActionNavigationItemModel implements INavigationItemModel {
    private String title;
    private int image;
    private Class activity;

    public ActionNavigationItemModel(String title, int image, Class activity) {
        this.title = title;
        this.image = image;
        this.activity = activity;
    }

    @Override
    public View constructView(LayoutInflater inflater, ViewGroup parent) {
        View rowView = inflater.inflate(R.layout.drawer_action_item, parent, false);

        TextView titleView = (TextView) rowView.findViewById(R.id.drawer_action_title);
        ImageView imageView = (ImageView) rowView.findViewById(R.id.drawer_action_img);

        titleView.setText(title);
        imageView.setImageResource(image);

        return rowView;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    public Class getActivity() {
        return activity;
    }
}
