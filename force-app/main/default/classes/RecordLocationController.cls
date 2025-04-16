public with sharing class RecordLocationController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Double> getRecordLocation(Id recordId) {
        System.debug('🔍 Fetching location for recordId: ' + recordId);

        if (recordId == null) {
            throw new AuraHandledException('Record ID is required');
        }

        String prefix = String.valueOf(recordId).substring(0, 3);
        SObject record;

        if (Schema.SObjectType.Account.getKeyPrefix() == prefix) {
            record = [SELECT BillingLatitude, BillingLongitude FROM Account WHERE Id = :recordId LIMIT 1];
            Double lat = ((Account)record).BillingLatitude;
            Double lng = ((Account)record).BillingLongitude;
            System.debug('📌 Account Coordinates: lat=' + lat + ', lng=' + lng);
            return new Map<String, Double>{ 'lat' => lat, 'lng' => lng };
        } else if (Schema.SObjectType.Contact.getKeyPrefix() == prefix) {
            record = [SELECT MailingLatitude, MailingLongitude FROM Contact WHERE Id = :recordId LIMIT 1];
            Double lat = ((Contact)record).MailingLatitude;
            Double lng = ((Contact)record).MailingLongitude;
            System.debug('📌 Contact Coordinates: lat=' + lat + ', lng=' + lng);
            return new Map<String, Double>{ 'lat' => lat, 'lng' => lng };
        } else if (Schema.SObjectType.Lead.getKeyPrefix() == prefix) {
            record = [SELECT Latitude, Longitude FROM Lead WHERE Id = :recordId LIMIT 1];
            Double lat = ((Lead)record).Latitude;
            Double lng = ((Lead)record).Longitude;
            System.debug('📌 Lead Coordinates: lat=' + lat + ', lng=' + lng);
            return new Map<String, Double>{ 'lat' => lat, 'lng' => lng };
        } else {
            System.debug('⚠️ Unsupported record type: ' + prefix);
            throw new AuraHandledException('Unsupported record type');
        }
    }
}
