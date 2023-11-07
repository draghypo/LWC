public class UtilClass {
   // GET ACCOUNT TYPES PICKLIST VALUES   
    @AuraEnabled(cacheable=true)
    public static List<String> getAccountTypePicklistValues() {
        List<String> typePicklistValues = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Type.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry entry : picklistEntries) {
            typePicklistValues.add(entry.getLabel());
        }
        return typePicklistValues;
    }
}
