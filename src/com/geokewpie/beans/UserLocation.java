package com.geokewpie.beans;

import java.util.Collection;
import java.util.Collections;

public class UserLocation {
    public static final String DATE_DELIMITER = "|";

    private String login;
    private Collection<DeviceLocation> devices;

    public UserLocation(String login, Collection<DeviceLocation> devices) {
        this.login = login;
        this.devices = devices;
    }

    public Collection<DeviceLocation> getDevices() {
        return devices == null ? Collections.<DeviceLocation>emptyList() : devices;
    }

    public void setDevices(Collection<DeviceLocation> devices) {
        this.devices = devices;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    @Override
    public String toString() {
        return "UserLocation{" +
                "login='" + login + '\'' +
                ", devices=" + devices +
                '}';
    }

}
