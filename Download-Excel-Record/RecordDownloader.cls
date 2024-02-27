public class RecordDownloader {
    @AuraEnabled
    public static List<Account> getAccount() {
        String accountQuery = 'SELECT Name, Type, Phone FROM Account WHERE Phone=\'sadiq\'';
        return Database.query(accountQuery);
    }
}