package com.geokewpie.providers;

import android.app.SearchManager;
import android.content.*;
import android.database.Cursor;
import android.database.MatrixCursor;
import android.net.Uri;
import android.preference.PreferenceManager;
import android.provider.BaseColumns;
import com.geokewpie.R;
import com.geokewpie.beans.User;
import com.geokewpie.content.Properties;
import com.geokewpie.network.NetworkTools;
import com.geokewpie.network.Response;
import com.google.gson.Gson;

import java.text.MessageFormat;

public class KewpiesContentProvider extends ContentProvider {

    public static final String AUTHORITY = "com.geokewpie.search_kewpies_provider";
    public static final Uri CONTENT_URI = Uri.parse("content://" + AUTHORITY + "/search");

    private static final int NO_SEARCH = 0;
    private static final int SEARCH_SUGGEST = 1;

    private static final UriMatcher uriMatcher;

    private static final String[] SEARCH_SUGGEST_COLUMNS = {
            BaseColumns._ID,
            SearchManager.SUGGEST_COLUMN_TEXT_1
    };

    static {
        uriMatcher = new UriMatcher(UriMatcher.NO_MATCH);
        uriMatcher.addURI(AUTHORITY, SearchManager.SUGGEST_URI_PATH_QUERY + "/*", SEARCH_SUGGEST);
    }

    @Override
    public boolean onCreate() {
        return true;
    }

    @Override
    public Cursor query(Uri uri, String[] strings, String s, String[] strings1, String s1) {
        MatrixCursor cursor = new MatrixCursor(SEARCH_SUGGEST_COLUMNS, 1);
        switch (uriMatcher.match(uri)) {
            case SEARCH_SUGGEST:
                SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(getContext());

                String email = settings.getString(Properties.EMAIL, "");
                String authToken = settings.getString(Properties.AUTH_TOKEN, "");

                System.out.println("uri.getLastPathSegment().toLowerCase() = " + uri.getLastPathSegment().toLowerCase());
                String url = MessageFormat.format("https://198.199.109.47:8080/users/find/{0}?email={1}&auth_token={2}", uri.getLastPathSegment().toLowerCase(), email, authToken);

                Response response;
                try {
                    System.out.println("1");
                    response = NetworkTools.sendGet(url);
                    System.out.println("2");
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }

                boolean suggestionsFound = false;
                if (response != null && response.isSuccessful()) {
                    User[] users = new Gson().fromJson(response.getBody(), User[].class);
                    for (User user : users) {
                        cursor.addRow(new String[] {
                                "1" /*todo*/, user.getLogin()
                        });
                        suggestionsFound = true;
                    }
                }

                if (!suggestionsFound) {
                    cursor.addRow(new String[] {
                            "1" /*todo*/, getContext().getResources().getString(R.string.nobody_found)
                    });
                }

                return cursor;
        }
        return cursor;
    }

    @Override
    public String getType(Uri uri) {
        switch (uriMatcher.match(uri)) {
            case SEARCH_SUGGEST:
                return SearchManager.SUGGEST_MIME_TYPE;
            default:
                throw new IllegalArgumentException("Unknown URL " + uri);
        }
    }

    @Override
    public Uri insert(Uri uri, ContentValues contentValues) {
        throw new UnsupportedOperationException();
    }

    @Override
    public int delete(Uri uri, String s, String[] strings) {
        throw new UnsupportedOperationException();
    }

    @Override
    public int update(Uri uri, ContentValues contentValues, String s, String[] strings) {
        throw new UnsupportedOperationException();
    }
}
