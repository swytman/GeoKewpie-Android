package com.geokewpie.beans;

public class UserLocation {
    private String login;
    private double latitude;
    private double longitude;

    public UserLocation(String login, double latitude, double longitude) {
        this.login = login;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    @Override
    public String toString() {
        return "Following{" +
                "login='" + login + '\'' +
                ", longitude=" + longitude +
                ", latitude=" + latitude +
                '}';
    }
}
