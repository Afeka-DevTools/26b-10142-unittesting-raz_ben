package org.example;

import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class AppTest {
    @Test
    void appCanBeInstantiated() {
        assertDoesNotThrow(App::new);
    }

    @Test
    void addSupportsPositiveNegativeAndZeroOperands() {
        assertAll(
                () -> assertEquals(7, App.add(3, 4)),
                () -> assertEquals(-2, App.add(3, -5)),
                () -> assertEquals(0, App.add(0, 0))
        );
    }

    @Test
    void isPrimeDistinguishesPrimesFromNonPrimesAndBoundaryValues() {
        assertAll(
                () -> assertFalse(App.isPrime(-7)),
                () -> assertFalse(App.isPrime(0)),
                () -> assertFalse(App.isPrime(1)),
                () -> assertTrue(App.isPrime(2)),
                () -> assertTrue(App.isPrime(13)),
                () -> assertFalse(App.isPrime(4)),
                () -> assertFalse(App.isPrime(49))
        );
    }

    @Test
    void reverseHandlesTextAndTheEmptyString() {
        assertAll(
                () -> assertEquals("!321cbA", App.reverse("Abc123!")),
                () -> assertEquals("", App.reverse(""))
        );
    }

    @Test
    void factorialHandlesBoundaryValuesIterationAndNegativeInput() {
        assertAll(
                () -> assertEquals(1, App.factorial(0)),
                () -> assertEquals(1, App.factorial(1)),
                () -> assertEquals(120, App.factorial(5))
        );

        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> App.factorial(-1)
        );
        assertEquals("Negative number", exception.getMessage());
    }

    @Test
    void isPalindromeIgnoresCaseAndNonAlphanumericCharacters() {
        assertAll(
                () -> assertTrue(App.isPalindrome("A man, a plan, a canal: Panama!")),
                () -> assertTrue(App.isPalindrome("")),
                () -> assertFalse(App.isPalindrome("OpenAI"))
        );
    }

    @Test
    void fibonacciUpToIncludesValuesAtOrBelowTheLimitAndRejectsNegativeLimits() {
        assertIterableEquals(
                List.of(0, 1, 1, 2, 3, 5, 8),
                App.fibonacciUpTo(10)
        );
        assertIterableEquals(List.of(0), App.fibonacciUpTo(0));

        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> App.fibonacciUpTo(-1)
        );
        assertEquals("Negative input", exception.getMessage());
    }

    @Test
    void charFrequencyCountsRepeatedDistinctAndWhitespaceCharacters() {
        Map<Character, Integer> frequencies = App.charFrequency("aab A");

        assertAll(
                () -> assertNotNull(frequencies),
                () -> assertEquals(2, frequencies.get('a')),
                () -> assertEquals(1, frequencies.get('b')),
                () -> assertEquals(1, frequencies.get(' ')),
                () -> assertEquals(1, frequencies.get('A')),
                () -> assertEquals(0, App.charFrequency("").size())
        );
    }

    @Test
    void isAnagramIgnoresWhitespaceAndCaseButDetectsDifferentLetters() {
        assertAll(
                () -> assertTrue(App.isAnagram("Dormitory", "Dirty room")),
                () -> assertTrue(App.isAnagram("", "")),
                () -> assertFalse(App.isAnagram("listen", "silentt"))
        );
    }

    @Test
    void averageComputesFractionalAndNegativeResultsAndRejectsAnEmptyArray() {
        assertAll(
                () -> assertEquals(2.5, App.average(new int[]{1, 2, 3, 4}), 0.000001),
                () -> assertEquals(-2.0, App.average(new int[]{-3, -2, -1}), 0.000001),
                () -> assertEquals(9.0, App.average(new int[]{9}), 0.000001)
        );

        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> App.average(new int[] {})
        );
        assertEquals("Empty array", exception.getMessage());
    }

    @Test
    void filterEvensKeepsOrderAndSupportsEmptyResults() {
        assertAll(
                () -> assertIterableEquals(
                        List.of(-2, 0, 4),
                        App.filterEvens(List.of(-2, -1, 0, 3, 4))
                ),
                () -> assertTrue(App.filterEvens(List.of(1, 3, 5)).isEmpty()),
                () -> assertTrue(App.filterEvens(List.of()).isEmpty())
        );
    }

    @Test
    void mostCommonWordIgnoresCaseAndPunctuation() {
        assertEquals(
                "java",
                App.mostCommonWord("Java, java; JAVA! Gradle gradle tests")
        );
    }
}
