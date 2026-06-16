
package org.example;

import java.util.*;

/**
 * Utility class providing various helper methods for mathematical operations,
 * string manipulations, and data processing.
 */
public class App {

    /**
     * Adds two integers.
     *
     * @param a the first integer
     * @param b the second integer
     * @return the sum of a and b
     */
    public static int add(int a, int b) {
        return a + b;
    }

    /**
     * Checks if a number is prime.
     *
     * @param n the number to check
     * @return true if n is prime, false otherwise
     */
    public static boolean isPrime(int n) {
        if (n < 2) return false;
        for (int i = 2; i <= Math.sqrt(n); i++) {
            if (n % i == 0) return false;
        }
        return true;
    }

    /**
     * Reverses a given string.
     *
     * @param s the string to reverse
     * @return the reversed string
     */
    public static String reverse(String s) {
        return new StringBuilder(s).reverse().toString();
    }

    /**
     * Calculates the factorial of a number.
     *
     * @param n the number to calculate the factorial for
     * @return the factorial of n
     * @throws IllegalArgumentException if n is negative
     */
    public static int factorial(int n) {
        if (n < 0) throw new IllegalArgumentException("Negative number");
        int result = 1;
        for (int i = 2; i <= n; i++) result *= i;
        return result;
    }

    /**
     * Checks if a string is a palindrome.
     *
     * @param s the string to check
     * @return true if s is a palindrome, false otherwise
     */
    public static boolean isPalindrome(String s) {
        String clean = s.replaceAll("[^a-zA-Z0-9]", "").toLowerCase();
        return clean.equals(reverse(clean));
    }

    /**
     * Generates a list of Fibonacci numbers up to a given limit.
     *
     * @param n the upper limit for Fibonacci numbers
     * @return a list of Fibonacci numbers up to n
     * @throws IllegalArgumentException if n is negative
     */
    public static List<Integer> fibonacciUpTo(int n) {
        List<Integer> result = new ArrayList<>();
        if (n < 0) throw new IllegalArgumentException("Negative input");
        int a = 0, b = 1;
        while (a <= n) {
            result.add(a);
            int temp = a + b;
            a = b;
            b = temp;
        }
        return result;
    }

    /**
     * Calculates the frequency of each character in a string.
     *
     * @param input the input string
     * @return a map containing characters as keys and their frequencies as values
     */
    public static Map<Character, Integer> charFrequency(String input) {
        Map<Character, Integer> freq = new HashMap<>();
        for (char c : input.toCharArray()) {
            freq.put(c, freq.getOrDefault(c, 0) + 1);
        }
        return freq;
    }

    /**
     * Checks if two strings are anagrams of each other.
     *
     * @param s1 the first string
     * @param s2 the second string
     * @return true if s1 and s2 are anagrams, false otherwise
     */
    public static boolean isAnagram(String s1, String s2) {
        char[] a1 = s1.replaceAll("\\s", "").toLowerCase().toCharArray();
        char[] a2 = s2.replaceAll("\\s", "").toLowerCase().toCharArray();
        Arrays.sort(a1);
        Arrays.sort(a2);
        return Arrays.equals(a1, a2);
    }

    /**
     * Calculates the average of an array of integers.
     *
     * @param arr the array of integers
     * @return the average of the integers in the array
     * @throws IllegalArgumentException if the array is empty
     */
    public static double average(int[] arr) {
        if (arr.length == 0) throw new IllegalArgumentException("Empty array");
        double sum = 0;
        for (int num : arr) sum += num;
        return sum / arr.length;
    }

    /**
     * Filters even numbers from a list of integers.
     *
     * @param list the list of integers
     * @return a list containing only the even numbers from the input list
     */
    public static List<Integer> filterEvens(List<Integer> list) {
        List<Integer> evens = new ArrayList<>();
        for (int n : list) {
            if (n % 2 == 0) evens.add(n);
        }
        return evens;
    }

    /**
     * Finds the most common word in a given text.
     *
     * @param text the input text
     * @return the most common word in the text
     */
    public static String mostCommonWord(String text) {
        String[] words = text.toLowerCase().split("\\W+");
        Map<String, Integer> count = new HashMap<>();
        for (String word : words) {
            count.put(word, count.getOrDefault(word, 0) + 1);
        }
        return Collections.max(count.entrySet(), Map.Entry.comparingByValue()).getKey();
    }
}