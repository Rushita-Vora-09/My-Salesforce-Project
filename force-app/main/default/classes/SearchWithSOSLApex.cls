public with sharing class SearchWithSOSLApex {
    
    @AuraEnabled(cacheable=true)
    public static Map<String, List<sObject>> searchWithSOSL(String searchKey, List<String> objects) {
        System.debug('Search Key: ' + searchKey);
        System.debug('Selected Objects: ' + objects);

        if (String.isEmpty(searchKey) || objects.isEmpty()) {
            return new Map<String, List<sObject>>();
        }
        
        String searchObjects = '';
        for (String obj : objects) {
            searchObjects += obj + '(Id, Name),';
        }

        String query = 'FIND \'' + String.escapeSingleQuotes(searchKey) + '\' IN ALL FIELDS RETURNING ' 
                        + searchObjects.removeEnd(',');

        // Execute the search
        List<List<sObject>> searchResult = search.query(query);
        
        Map<String, List<sObject>> formattedResults = new Map<String, List<sObject>>();
        Integer index = 0;
        
        for (String objName : objects) {
            if (index < searchResult.size()) {
                formattedResults.put(objName, searchResult[index]);
            } else {
                formattedResults.put(objName, new List<sObject>());
            }
            index++;
        }

        return formattedResults;
    }
}