package com.lxwfyw.junit;

import org.junit.jupiter.api.*;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;
import org.junit.jupiter.params.provider.ValueSource;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

/**
 * <b>Lifecycle methods</b>
 * BeforeEach/ AfterEach/ BeforeAll/ AfterAll
 * The annotated method should be executed before/ after each/ all test method(s)
 * Flexible versions of these - use ExtendWith
 * <p>
 * <b>Tags</b>
 * Tag e.g. "@Tag("smoke")"
 * We can use this annotation to declare tags for filtering tests, either at the class or method level.
 * useful when we want to create a test pack with selected tests.
 * <p>
 * Disabled (aka Ignore)
 *
 * @see <a href="https://www.baeldung.com/parameterized-tests-junit-5">parameterized tests</a>
 */

class JUnitFeaturesEgTest {

//    @ParameterizedTest
//    @DisplayName("ParameterizedTest")
//    @ValueSource(ints = {1, 3, 5, -3, 15, Integer.MAX_VALUE})
//    // @NullSource - injects null
//    void isOdd(int number) {
//        assertTrue(Features.isOdd(number));
//    }

    @DisplayName("ParameterizedTest (ValueSource)")
    @ParameterizedTest
    @ValueSource(strings = {"cali", "bali", "dani"})
        // @NullSource, MethodSource, CsvSource, EnumSource etc....
    void endsWithI(String str) {
        assertTrue(str.endsWith("i"));
    }

    @DisplayName("ParameterizedTest (MethodSource)")
    @ParameterizedTest
    @MethodSource("provideStringsForIsBlank")
    void isEmpty_ShouldReturnTrueForNullOrBlankStrings(String input, boolean expected) {
        assertEquals(expected, input.isEmpty());
    }

    static List<String> asia() {
        return Arrays.asList("Japan", "India", "Thailand");
    }

    static List<String> europe() {
        return Arrays.asList("Spain", "Italy", "England");
    }

    @DisplayName("ParameterizedTest (MethodSource x2)")
    @ParameterizedTest
    @MethodSource("asia")
    @MethodSource("europe")
    void whenStringIsLargerThanThreeCharacters_thenReturnTrue(String country) {
        assertTrue(country.length() > 3);
    }

    /**
     * The supported sources are:
     * * @ValueSource
     * * @EnumSource
     * * @MethodSource
     * * @FieldSource
     * * @CsvSource
     * * @CsvFileSource
     * * @ArgumentsSource
     *
     * @see <a href="https://www.baeldung.com/parameterized-tests-junit-5#conversion">argument conversion</a>
     */

    private static Stream<Arguments> provideStringsForIsBlank() {
        return Stream.of(Arguments.of(null, true), Arguments.of("", true), Arguments.of("  ", true), Arguments.of("not blank", false));
    }

    @DisplayName("RepeatingTest")
    @RepeatedTest(value = 5, name = "{displayName} {currentRepetition}/{totalRepetitions}")
    void customDisplayName(RepetitionInfo repInfo, TestInfo testInfo) {
        int i = 3;
        System.out.println(testInfo.getDisplayName() + "-->" + repInfo.getCurrentRepetition());
        assertEquals(repInfo.getCurrentRepetition(), i);
    }

    /**
     * Assumption methods in JUnit 5 allow you to define certain conditions that must be
     * satisfied for the test to continue executing. If an assumption fails, the test is not
     * marked as failed but is instead aborted. Assumptions are particularly useful when you have
     * tests that depend on certain conditions, and you want to skip those tests if the
     * conditions  are not met. Assumptions are used to setup conditions for the test to run,
     * failure means test is N/ A
     */
    @DisplayName("Assumptions")
    @Test
    public void testFileExists() {
        assumeTrue(System.getProperty("os.name").startsWith("Windows"));
        // The test code to check a file on Windows
    }

    /*****************************************************************************************
     * Nested annotation allows you to create nested inner classes within a test class. This
     * facilitates better organization and encapsulation of tests. For instance, when testing a
     * class with multiple methods, you can use nested classes to group related tests together.
     */
    @Nested
    class AdditionTests {
        @DisplayName("Nested_TestsA1")
        @Test
        void testPositiveNumbers() { /* Test addition of positive numbers */}

        @DisplayName("Nested_TestsA2")
        @Test
        void testNegativeNumbers() { /* Test addition of negative numbers */}
    }

    @Nested
    class SubtractionTests {
        @DisplayName("Nested_TestsB1")
        @Test
        void testPositiveNumbers() { /* Test subtraction of positive numbers */}

        @DisplayName("Nested_TestsB2")
        @Test
        void testNegativeNumbers() { /* Test subtraction of negative numbers */}
    }

}
