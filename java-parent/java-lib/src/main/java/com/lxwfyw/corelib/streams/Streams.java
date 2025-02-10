package com.lxwfyw.corelib.streams;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

public class Streams {

    public record State(String name) {}
    public record City(String name, State state) {}

    public record NumberOfCitiesPerState(State state, long numberOfCities) {
        public NumberOfCitiesPerState(Map.Entry<State, Long> entry) {
            this(entry.getKey(), entry.getValue());
        }
        public static Comparator<NumberOfCitiesPerState> comparingByNumberOfCities() {
            return Comparator.comparing(NumberOfCitiesPerState::numberOfCities);
        }
    }

    public static void groupCitiesByState(List<City> cities) {
        Map<State, Long> numberOfCitiesPerState = cities.stream().collect(
                Collectors.groupingBy(City::state, Collectors.counting()));
        /**
         * This last piece of code is technical; it does not carry any business meanings;
         * >> because is uses Map.Entry instance to model every element of the histogram.
         */
        Map.Entry<State, Long> entry = numberOfCitiesPerState.entrySet().stream()
                /**
                 * @see Comparator#comparing(Function f)
                 * TODO: Example of using functional interfaces
                 */
                .max(Map.Entry.comparingByValue())
                .orElseThrow();
        /*
         * Using a local record can greatly improve this situation.
         * >> We wrap the Map.Entry into a record, allowing us to do map().max()
         * >> because max takes a comparator
         */
        NumberOfCitiesPerState stateWithTheMostCities =
                numberOfCitiesPerState.entrySet().stream()
                        .map(NumberOfCitiesPerState::new)
                        .max(NumberOfCitiesPerState.comparingByNumberOfCities())
                        .orElseThrow();
    }
}
