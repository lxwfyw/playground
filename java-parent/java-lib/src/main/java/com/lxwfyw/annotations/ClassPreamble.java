package com.lxwfyw.annotations;

import java.lang.annotation.Documented;

/**
 * Note: To make the information in @ClassPreamble appear in Javadoc-generated documentation,
 * you must annotate the @ClassPreamble definition with the @Documented annotation:
 */
@Documented
@interface ClassPreamble {
    String author();
    String date();
    int currentRevision() default 1;
    String lastModified() default "N/A";
    String lastModifiedBy() default "N/A";
    // Note use of array
    String[] reviewers();
}

/**
 * Use it like this
 @ClassPreamble (
         author = "John Doe",
         date = "3/17/2002",
         currentRevision = 6,
         lastModified = "4/12/2004",
         lastModifiedBy = "Jane Doe",
         // Note array notation
         reviewers = {"Alice", "Bob", "Cindy"}
         )
 public class Generation3List extends Generation2List {
 }
 */
