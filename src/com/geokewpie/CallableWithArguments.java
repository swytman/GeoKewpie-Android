package com.geokewpie;

public interface CallableWithArguments<T, V> {
    T call(V v) throws Exception;
}
