package so.util;

import java.io.IOException;
import java.net.CookiePolicy;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLConnection;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public class CookieManager {

    private final java.net.CookieManager cookieStore;

    public CookieManager() {
        cookieStore = new java.net.CookieManager(null, CookiePolicy.ACCEPT_ORIGINAL_SERVER);
    }

    public void storeCookies(URLConnection conn) throws IOException {
        cookieStore.put(getURI(conn), conn.getHeaderFields());
    }

    public void setCookies(URLConnection conn) throws IOException {
        Map<String, List<String>> headers = cookieStore.get(getURI(conn), Collections.<String, List<String>>emptyMap());
        for (Map.Entry<String, List<String>> header : headers.entrySet()) {
            for (String value : header.getValue()) {
                conn.addRequestProperty(header.getKey(), value);
            }
        }
    }

    private URI getURI(URLConnection conn) throws IOException {
        try {
            return conn.getURL().toURI();
        } catch (URISyntaxException e) {
            throw new IOException("Invalid URL for cookie handling: " + conn.getURL(), e);
        }
    }
}
