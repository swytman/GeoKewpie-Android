package com.geokewpie.drawer.models;

import android.view.*;

public interface INavigationItemModel {
    public View constructView(LayoutInflater inflater, ViewGroup parent);

    public boolean isEnabled();
}
