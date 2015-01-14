package com.geokewpie.network.exception;

public class NetworkException extends Exception {
    private String message;
    public NetworkException(String message) {
        this.message = message;
    }

    @Override
    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    @Override
    public String toString() {
        return "NetworkException{" +
                "message='" + message + '\'' +
                '}';
    }
}
