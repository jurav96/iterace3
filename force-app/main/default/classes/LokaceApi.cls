// Tato anotace definuje, že tato třída bude sloužit jako REST Resource
// a stanovuje URL mapping pro tento endpoint (v tomto případě '/Lokace/*')
@RestResource(urlMapping='/Lokace/*')
global class LokaceApi {
 	// Anotace @HttpPost definuje, že následující metoda bude sloužit jako
    // obsluha HTTP POST požadavků
    @HttpPost
    // Tato metoda je globální, takže může být volána z jiných tříd nebo prostředků,

    global static String upsertLokace(List<Lokace__c> lokaceList) {
        // Operace upsert je kombinace operací 'insert' a 'update'.
        // Pokud záznam neexistuje (podle Salesforce ID nebo externího ID),
        // bude vložen. Pokud existuje, bude aktualizován.
        try {
            upsert lokaceList;
            // V případě úspěšné operace upsert vrátíme úspěšnou hlášku
            return 'Upsert operace proběhla úspěšně.';
        } catch (Exception e) {
            // V případě chyby vrátíme chybovou hlášku obsahující informace o výjimce
            return 'Chyba při upsert operaci: ' + e.getMessage();
        }
    }
}