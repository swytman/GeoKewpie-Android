package com.geokewpie.drawer.models;

import android.content.Context;
import android.view.*;
import android.widget.TextView;
import com.geokewpie.R;
import com.geokewpie.beans.DeviceLocation;

public class FollowingNavigationItemModel implements INavigationItemModel {
    private String title;
    private DeviceLocation deviceLocation;
    private Context context;

    public FollowingNavigationItemModel(String title, DeviceLocation deviceLocation, Context context) {
        this.title = title;
        this.deviceLocation = deviceLocation;
        this.context = context;
    }

    @Override
    public View constructView(LayoutInflater inflater, ViewGroup parent) {
        View rowView = inflater.inflate(R.layout.drawer_kewpie_item, parent, false);

        TextView titleView = (TextView) rowView.findViewById(R.id.drawer_item_title);
        TextView updatedTimeView = (TextView) rowView.findViewById(R.id.drawer_item_upd_time);

        titleView.setText(title);
        updatedTimeView.setText(deviceLocation.updatedAgo(context, true));

        return rowView;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    public DeviceLocation getDeviceLocation() {
        return deviceLocation;
    }
}
