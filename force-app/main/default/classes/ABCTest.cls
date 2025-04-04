@isTest  
public with sharing class ABCTest {
    
    @isTest
    public static void abcTest() {
        Test.startTest(); // Start test context
        
        // Instantiate the ABC class to cover the constructor
        ABC abcInstance = new ABC();
        
        // Test case where input is 'abc'
        String result1 = ABC.abc('abc');
        System.assertEquals('ABC', result1, 'Expected ABC for input "abc"');

        // Test case where input is not 'abc'
        String result2 = ABC.abc('xyz');
        System.assertEquals('Not ABC', result2, 'Expected Not ABC for input "xyz"');

        Test.stopTest(); // Stop test context
    }
}