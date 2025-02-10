package com.lxwfyw.corelib;

import java.io.*;

public class Records {

    // Define a record that implements Serializable
    public record Person(String name, int age) implements Serializable {

        // Custom serialization with writeReplace
        @Serial
        private Object writeReplace() throws ObjectStreamException {
            // For example, replace with an encrypted version or some transformation
            return new Person("Encrypted-" + name, age); // Modified before serializing
        }

        // Custom deserialization with readResolve
        @Serial
        private Object readResolve() throws ObjectStreamException {
            // For example, restoring original values or other custom logic
            if (name.startsWith("Encrypted-")) {
                return new Person(name.substring(10), age); // Remove encryption prefix during deserialization
            }
            return this; // No changes if it's not encrypted
        }
    }

    public static void main(String[] args) {
        Person person = new Person("John", 30);

        try (ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream("person.ser"));
             ObjectInputStream in = new ObjectInputStream(new FileInputStream("person.ser"))) {

            // Serialize the person object
            out.writeObject(person);

            // Deserialize the person object
            Person deserializedPerson = (Person) in.readObject();
            System.out.println("Deserialized person: " + deserializedPerson);
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
