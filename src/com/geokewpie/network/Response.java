package com.geokewpie.network;

public class Response {
    private int resultCode;
    private String body;

    public Response() {
    }

    public Response(int resultCode, String body) {
        this.resultCode = resultCode;
        this.body = body;
    }

    public int getResultCode() {
        return resultCode;
    }

    public void setResultCode(int resultCode) {
        this.resultCode = resultCode;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public boolean isSuccessful() {
        return resultCode / 100 == 2;
    }

    @Override
    public String toString() {
        return "Response{" +
                "resultCode=" + resultCode +
                ", body='" + body + '\'' +
                '}';
    }
}
