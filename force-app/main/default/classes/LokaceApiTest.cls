@IsTest
public class LokaceApiTest {
// Tato metoda vytvoří testovací data pro objekt Lokace__c
    private static List<Lokace__c> createTestLokace(Integer numRecords) {
        List<Lokace__c> lokaceList = new List<Lokace__c>();
        for (Integer i = 1; i <= numRecords; i++) {
            Lokace__c lokace = new Lokace__c(
                Name = 'Test Lokace ' + i,
                Kapacita__c = i
            );
            lokaceList.add(lokace);
        }
        return lokaceList;
    }

    // Tato metoda testuje úspěšnou upsert operaci
    @IsTest
    static void testUpsertLokaceSuccess() {
        // Připravíme testovací data
        List<Lokace__c> lokaceList = createTestLokace(2);

        // Nastavíme testovací prostředí pro REST API
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Lokace';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf(JSON.serialize(lokaceList));
        RestContext.request = req;
        RestContext.response = res;

        // Zavoláme metodu upsertLokace a ověříme, zda byla operace úspěšná
        Test.startTest();
        String result = LokaceApi.upsertLokace(lokaceList);
        Test.stopTest();
        System.assertEquals('Upsert operace proběhla úspěšně.', result);
    }
        
}