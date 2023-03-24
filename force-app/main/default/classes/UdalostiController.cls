public with sharing class UdalostiController {
    @AuraEnabled(cacheable=true)
    public static List<UdalostiWrapper> getMojeUdalosti() {
        Id userId = UserInfo.getUserId();
        List<UdalostiWrapper> wrappers = new List<UdalostiWrapper>();
        for (Rezervace__c rezervace : [SELECT Id, Udalost__r.Id, Udalost__r.Name, Udalost__r.Lokace__r.Name, Udalost__r.Datum_Ud_losti__c
                                   FROM Rezervace__c
                                   WHERE Pracovnik__c = :userId]) {
            UdalostiWrapper wrapper = new UdalostiWrapper();
            wrapper.udalostId = rezervace.Udalost__r.Id;
            wrapper.lokaceName = rezervace.Udalost__r.Lokace__r.Name;
            wrapper.udalostName = rezervace.Udalost__r.Name;
            wrapper.udalostDate = rezervace.Udalost__r.Datum_Ud_losti__c;
            wrappers.add(wrapper);
        }
        return wrappers;
    }

    @AuraEnabled(cacheable=true)
    public static List<UdalostiWrapper> getUdalosti() {
        List<UdalostiWrapper> wrappers = new List<UdalostiWrapper>();
        for (Udalost__c udalost : [SELECT Id, Name, Lokace__r.Name, Datum_Ud_losti__c FROM Udalost__c]) {
            UdalostiWrapper wrapper = new UdalostiWrapper();
            wrapper.udalostId = udalost.Id;
            wrapper.lokaceName = udalost.Lokace__r.Name;
            wrapper.udalostName = udalost.Name;
            wrapper.udalostDate = udalost.Datum_Ud_losti__c;
            wrappers.add(wrapper);
        }
        return wrappers;
    }

    @AuraEnabled
    public static void prihlasitSeNaUdalost(Id udalostId) {
        Id userId = UserInfo.getUserId();
        Rezervace__c rezervace = new Rezervace__c(Udalost__c=udalostId, Pracovnik__c=userId);
        try{
            insert rezervace;
        }catch(Exception ex){
             System.debug(ex);
             throw new AuraHandledException(ex.getMessage());
        }
        
    }

    public class UdalostiWrapper {
        @AuraEnabled
        public Id udalostId;
        @AuraEnabled
        public String lokaceName;
        @AuraEnabled
        public String udalostName;
        @AuraEnabled
        public DateTime udalostDate;
    }
}