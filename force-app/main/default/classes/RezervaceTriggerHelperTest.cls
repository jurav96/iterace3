@isTest
private class RezervaceTriggerHelperTest {
 // Pomocná metoda pro vytvoření testovacích dat: Lokace__c a Udalost__c
    private static void createTestData() {
        // Vytvoříme testovací Lokace__c záznam
        Lokace__c testLokace = new Lokace__c(Name='Test Lokace', Kapacita__c=1);
        insert testLokace;

        // Vytvoříme testovací Udalost__c záznam
        Udalost__c testUdalost = new Udalost__c(Name='Test Udalost', Lokace__c=testLokace.Id);
        insert testUdalost;
    }

    // Testovací metoda pro validateCapacity() - testování kapacity
    @IsTest
    static void testValidateCapacity() {
        createTestData();

        // Query pro získání testovací Udalost__c záznamu
        Udalost__c testUdalost = [SELECT Id FROM Udalost__c WHERE Name='Test Udalost' LIMIT 1];

        // Vytvoříme první testovací Rezervace__c záznam
        Rezervace__c rezervace1 = new Rezervace__c(Udalost__c=testUdalost.Id, Stav__c = 'Schválená');
        // Vytvoříme druhý testovací Rezervace__c záznam
        Rezervace__c rezervace2 = new Rezervace__c(Udalost__c= testUdalost.Id, Pracovnik__c = UserInfo.getUserId(), Stav__c = 'Schválená');

        Test.startTest();
        // Vložíme první testovací Rezervace__c záznam
        insert rezervace1;
        // Ověříme, že se úspěšně vložil
        System.assertEquals(1, [SELECT COUNT() FROM Rezervace__c]);

        // Pokus o vložení druheho testovacího Rezervace__c záznamu, který by měl překročit kapacitu
        String expectedErrorMessage = 'Kapacita je naplněná!';
        String errorHappened;
        try {
            insert rezervace2;
        } catch (DmlException e) {
            errorHappened = e.getDmlMessage(0);
        }
        Test.stopTest();
        // Ověříme, že chybová hláška je správná
        System.assertEquals(expectedErrorMessage, errorHappened);
    }
}