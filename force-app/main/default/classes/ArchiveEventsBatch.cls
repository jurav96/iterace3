// Třída ArchiveEventsBatch implementuje rozhraní Database.Batchable<sObject>
global class ArchiveEventsBatch implements Database.Batchable<sObject> {
    // Metoda 'start' je povinná pro rozhraní Database.Batchable<sObject>
    // a je zodpovědná za vrácení QueryLocatoru s query pro zpracování dávkou
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Získáme datum přesně o rok zpět
        DateTime oneYearAgo = System.now().addYears(-1);
        // Vytvoříme SOQL dotaz pro vybrání událostí starších než jeden rok
        String query = 'SELECT Id, Datum_Ud_losti__c FROM Udalost__c WHERE Datum_Ud_losti__c < :oneYearAgo';
        // Vracíme QueryLocator s dotazem
        return Database.getQueryLocator(query);
    }
    
    // Metoda 'execute' je povinná pro rozhraní Database.Batchable<sObject>
    // a je zodpovědná za zpracování dávky záznamů
    global void execute(Database.BatchableContext BC, List<Udalost__c> scope) {
       // Vytvoříme seznam událostí k archivaci
        List<Udalost__c> eventsToArchive = new List<Udalost__c>();
        // Projdeme všechny záznamy v dávce
        for (Udalost__c event : scope) {
            // Nastavit archivační atribut na 'true' nebo provést jinou akci
            // event.Archived__c = true;
            eventsToArchive.add(event);
        }
        
         // Pokud máme události k archivaci, aktualizujeme je v Salesforce
        if (!eventsToArchive.isEmpty()) {
            update eventsToArchive;
        }
    }
    
    // Metoda 'finish' je povinná pro rozhraní Database.Batchable<sObject>
    // a je zodpovědná za zpracování akcí po dokončení celého batchu
    global void finish(Database.BatchableContext BC) {
    // Zde můžete provést další akce po dokončení batchu, například poslat e-mail o úspěšném dokončení
	}
}