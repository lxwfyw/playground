package com.lxwfyw.corelib;

import org.junit.jupiter.api.Test;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.stream.IntStream;

class DeclarativeStyleTest {

    @Test void iterateInsteadofLoops() {
        // for(int i = 0; i < 5; i++) {
        //  System.out.println(i);
        //}
        IntStream.range(0, 5).forEach(System.out::println);

        // for(int i = 0; i <= 5; i++) {
        //  System.out.println(i);
        //}
        IntStream.rangeClosed(0, 5)
                .forEach(System.out::println);

        // for(int i = 0; i < 15; i = i + 3)
        IntStream.iterate(0, i -> i < 15, i -> i + 3)
                .forEach(System.out::println);

        //for(int i = 0;; i = i + 3) {
        //  if(i > 20) {
        //    break;
        //  }
        //
        //  System.out.println(i);
        //}
        IntStream.iterate(0, i -> i + 3)
                .takeWhile(i -> i <= 20)
                .forEach(System.out::println);
    }

    @Test void iteratingWithForeach() {
        // for(String name: names)
        List<String> names = List.of("Jack", "Paula", "Kate", "Peter");
        names.forEach(System.out::println);
        names.stream().forEach(System.out::println);

        //for(String name: names) {
        //  if(name.length() == 4) {
        //    System.out.println(name);
        //  }
        //}
        names.stream().filter(name -> name.length() == 4).forEach(System.out::println);
    }

    @Test void transformingWhileIterating() {
        List<String> names = List.of("Jack", "Paula", "Kate", "Peter");
        names.stream().map(String::toUpperCase).forEach(System.out::println);
    }

    @Test void convertDataSourcesToStreams() {
        // while((line = reader.readLine()) != null) {
        //          if(line.contains(wordOfInterest)) {
        //            count++;
        //          }
        //        }
        try {
            final var filePath = "./Sample.java";
            final var wordOfInterest = "public";

            try(var stream = Files.lines(Path.of(filePath))) {
                long count = stream.filter(line -> line.contains(wordOfInterest)).count();
                System.out.format("Found %d lines with the word %s%n", count, wordOfInterest);
            }
        } catch(Exception ex) {
            System.out.println("ERROR: " + ex.getMessage());
        }
    }
}
