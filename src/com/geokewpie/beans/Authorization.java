package com.geokewpie.beans;

public class Authorization {
    private String auth_token;
    private String refresh_token;

    public Authorization(String auth_token, String refresh_token) {
        this.auth_token = auth_token;
        this.refresh_token = refresh_token;
    }

    public String getAuth_token() {
        return auth_token;
    }

    public void setAuth_token(String auth_token) {
        this.auth_token = auth_token;
    }

    public String getRefresh_token() {
        return refresh_token;
    }

    public void setRefresh_token(String refresh_token) {
        this.refresh_token = refresh_token;
    }
}
