package com.geokewpie.drawer;

import android.content.Context;
import android.view.*;
import android.widget.ArrayAdapter;
import com.geokewpie.R;
import com.geokewpie.drawer.models.HeaderNavigationItemModel;
import com.geokewpie.drawer.models.INavigationItemModel;

import java.util.List;

public class GKNavigationAdapter extends ArrayAdapter<INavigationItemModel> {
    private Context context;
    private List<INavigationItemModel> models;

    public GKNavigationAdapter(Context context, List<INavigationItemModel> models) {
        super(context, R.layout.drawer_kewpie_item, models);

        this.context = context;
        this.models = models;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        INavigationItemModel model = models.get(position);
        return model.constructView(inflater, parent);
    }

    @Override
    public boolean areAllItemsEnabled() {
        return false;
    }

    @Override
    public boolean isEnabled(int position) {
        return models.get(position).isEnabled();
    }
}
