package com.lxwfyw.algorithms.list;

import java.util.List;
import java.util.function.Predicate;

public class FirstInList {

    /**
     * How do you invoke the following method to find the first integer in a list that is relatively prime to a list of specified integers?
     * <pre>{@code
     * public static <T>
     *     int findFirst(List<T> list, int begin, int end, UnaryPredicate<T> p)
     * }</pre>

     * Note that two integers a and b are relatively prime if gcd(a, b) = 1, where gcd is short for greatest common divisor.
     *
     * @see
     * <a href="https://docs.oracle.com/javase/tutorial/java/generics/QandE/generics-answers.html#:~:text=Answer%3A%20Yes.-,How%20do%20you,-invoke%20the%20following">link</a>
     *
     */
    public static <T>
    int findFirst(List<T> list, int begin, int end, Predicate<T> p) {
        for (int i = begin; i < end; i++) {
            if (p.test(list.get(i))) {
                return i;
            }
        }
        return -1;
    }

    // x > 0 and y > 0
    // if no common divisor, result should be 1
    /**
     * 14,6
     * 6,2
     * 2,0
     *
     * 6,14
     * 14,6
     *
     * 19,17
     * 17,2
     * 2,1
     */
    public static int greatestCommonDivisor(int x, int y) {
        while (y != 0) {    // base case, y is the result of the modulo operation
            int temp = y;   // on the next iteration, x = y, y = new_modulo_result
            y = x % y;
            x = temp;
        }
        return x;
    }
}
