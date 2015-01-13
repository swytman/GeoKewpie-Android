package com.geokewpie.beans;

public class UserLocation {
    private String login;
    private double latitude;
    private double longitude;
    private String updated_at;

    public UserLocation(double latitude, double longitude) {
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

    public String getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(String updated_at) {
        this.updated_at = updated_at;
    }

    @Override
    public String toString() {
        return "UserLocation{" +
                "login='" + login + '\'' +
                ", latitude=" + latitude +
                ", longitude=" + longitude +
                ", updated_at='" + updated_at + '\'' +
                '}';
    }
}
