package com.geokewpie.drawer.models;

import android.view.*;
import android.widget.TextView;
import com.geokewpie.R;

public class HeaderNavigationItemModel implements INavigationItemModel {
    private String title;

    public HeaderNavigationItemModel(String title) {
        this.title = title;
    }

    @Override
    public View constructView(LayoutInflater inflater, ViewGroup parent) {
        View rowView = inflater.inflate(R.layout.drawer_header_item, parent, false);
        TextView titleView = (TextView) rowView.findViewById(R.id.drawer_header_title);
        titleView.setText(title);

        return rowView;
    }

    @Override
    public boolean isEnabled() {
        return false;
    }
}
