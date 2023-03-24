public class RezervaceTriggerHelper {
    
    // Tato metoda zpracovává seznam rezervací a automaticky je odesílá ke schválení
    public static void automaticallySendFoApproval(List<Rezervace__c> reservations){
        // Vytvoříme nový seznam pro ukládání ID rezervací
        List<Id> newReservationIds = new List<Id>();
        // Iterujeme přes rezervace a přidáme jejich ID do seznamu newReservationIds
        for (Rezervace__c reservation : reservations) {
            if(reservation.Stav__c != 'Nova') continue;
            newReservationIds.add(reservation.Id);
        }
        
        // Spustit Queueable úlohu pro odeslání rezervací ke schválení
        // Vytvoříme instanci třídy SubmitReservationForApproval a předáme jí seznam ID rezervací
        SubmitReservationForApproval submitForApproval = new SubmitReservationForApproval(newReservationIds);
        // Spustíme úlohu ve frontě pomocí metody System.enqueueJob()
        System.enqueueJob(submitForApproval);
    }
    // Tato metoda ověřuje kapacitu události pro rezervace
    public static void validateCapacity(List<Rezervace__c> reservations){
        // Vytvoříme seznam pro ukládání ID událostí
        List<Id> udalostIds = new List<Id>();
        // Iterujeme přes rezervace a přidáme jejich události (Udalost__c) do seznamu udalostIds
        for(Rezervace__c rezervace : reservations){
            udalostIds.add(rezervace.Udalost__c);
        }
         // Vytvoříme mapy pro ukládání kapacity a obsazenosti událostí
        Map<Id, Integer> kapacitaByUdalostId = new Map<Id, Integer>();
        Map<Id, Integer> obsazenostByUdalostId = new Map<Id, Integer>();
        // Query pro načítání kapacity a obsazenosti pro každou událost
        for(Udalost__c udalost : [SELECT Lokace__r.Kapacita__c, (SELECT Id FROM Rezervace__r WHERE Stav__c = 'Čeká schválení' OR Stav__c = 'Schválená') 
                                  FROM Udalost__c WHERE Id IN :udalostIds]){
                                      
             kapacitaByUdalostId.put(udalost.Id, (Integer)udalost.Lokace__r.Kapacita__c);
             obsazenostByUdalostId.put(udalost.Id, udalost.Rezervace__r.size());
       	}
        // Iterujeme přes rezervace a ověříme, zda kapacita události není naplněna
        for(Rezervace__c rezervace : reservations){
            // Pokud je kapacita události menší nebo rovna
            if(kapacitaByUdalostId.get(rezervace.Udalost__c) <= obsazenostByUdalostId.get(rezervace.Udalost__c)){
                rezervace.addError('Kapacita je naplněná!');
            }
        }
    }
}