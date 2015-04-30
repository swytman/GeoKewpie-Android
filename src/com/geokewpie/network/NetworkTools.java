package com.geokewpie.network;

import com.geokewpie.network.exception.NetworkException;

import javax.net.ssl.*;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.net.ConnectException;
import java.net.HttpURLConnection;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.security.cert.X509Certificate;

public class NetworkTools {

    public static Response sendRequest(String url, String json, String requestMethod) throws Exception {
        try {
            TrustManager[] trustAllCerts = new TrustManager[]{new X509TrustManager() {
                public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                    return null;
                }

                public void checkClientTrusted(X509Certificate[] certs, String authType) {
                }

                public void checkServerTrusted(X509Certificate[] certs, String authType) {
                }
            }
            };

            // Install the all-trusting trust manager
            SSLContext sc = SSLContext.getInstance("SSL");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

            // Create all-trusting host name verifier
            HostnameVerifier allHostsValid = new HostnameVerifier() {
                public boolean verify(String hostname, SSLSession session) {
                    return true;
                }
            };

            // Install the all-trusting host verifier
            HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);

            HttpURLConnection con = (HttpURLConnection) new URL(url).openConnection();

            con.setConnectTimeout(20000); // 20 sec timeout
            con.setReadTimeout(5000); // 5 sec timeout
            con.setRequestMethod(requestMethod);

            if (json != null) {
                con.setDoOutput(true);
                con.setDoInput(true);
                con.setRequestProperty("Content-Type", "application/json");
                con.setRequestProperty("Connection", "close");
                con.setRequestProperty("Accept", "");

                OutputStreamWriter outputStream = new OutputStreamWriter(con.getOutputStream());
                outputStream.write(json);
                outputStream.close();
            }

            Response response = new Response();

            int responseCode = con.getResponseCode();
            response.setResultCode(responseCode);

            Reader reader;
            if (response.isSuccessful()) { // success
                reader = new InputStreamReader(con.getInputStream());
            } else {
                reader = new InputStreamReader(con.getErrorStream());
            }

            StringBuilder sb = new StringBuilder();
            while (true) {
                int ch = reader.read();
                if (ch == -1) {
                    break;
                }
                sb.append((char) ch);
            }
            reader.close();

            response.setBody(sb.toString());

            System.out.println("url = " + url);
            System.out.println("response = " + response);

            return response;
        } catch (ConnectException e) {
            throw new NetworkException();
        } catch (SSLException e) {
            throw new NetworkException();
        } catch (SocketTimeoutException e) {
            throw new NetworkException();
        }
    }

    public static Response sendPost(String url, String json) throws Exception {
        return sendRequest(url, json, "POST");
    }

    public static Response sendPost(String url) throws Exception {
        return sendPost(url, null);
    }

    public static Response sendGet(String url) throws Exception {
        return sendRequest(url, null, "GET");
    }

    public static Response sendDelete(String url) throws Exception {
        return sendRequest(url, null, "DELETE");
    }

}