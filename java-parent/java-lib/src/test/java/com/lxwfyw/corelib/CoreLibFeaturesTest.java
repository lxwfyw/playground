package com.lxwfyw.corelib;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;

class CoreLibFeaturesTest {


    @Test
    void toArrayTest() {
        var list = new java.util.ArrayList<String>();
        list.add("foo");
        list.add("bar");
        var array = list.toArray(String[]::new);
        assertArrayEquals(new String[]{"foo", "bar"}, array);
    }

    @ParameterizedTest
    @ValueSource(strings = {"foo"})
    void patternMatching(Object o) {
        if (!(o instanceof String s1)) {
            return;
        }
        System.out.println("This is a String of length " + s1.length());

        Object o1 = "foo"; // any object
        String formatter1 = switch(o1) {
            case Integer i -> String.format("int %d", i);
            case Long l    -> String.format("long %d", l);
            case Double d  -> String.format("double %f", d);
            default        -> String.format("Object %s", o.toString());
        };

        Object o2 = "bar"; // any object
        String formatter2 = switch(o2) {
            case String s2 when !s2.isEmpty() -> String.format("Non-empty string %s", s2);
            default                         -> String.format("Object %s", o.toString());
        };
    }
}
