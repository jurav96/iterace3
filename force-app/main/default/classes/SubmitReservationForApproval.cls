public class SubmitReservationForApproval implements Queueable {
     
    // Seznam ID rezervací, které mají být odeslány ke schválení
    private final List<Id> reservationIds;
    // Konstruktor třídy, který přijímá seznam ID rezervací
    public SubmitReservationForApproval(List<Id> reservationIds) {
        this.reservationIds = reservationIds;
    }
    
    // Hlavní metoda, která se spustí, když je tato třída zařazena do fronty
    public void execute(QueueableContext context) {
        // Načtěte rezervace podle zadaných ID
        List<Rezervace__c> reservations = [
            SELECT Id
            FROM Rezervace__c
            WHERE Id IN :reservationIds
        ];
        
        // Připravit seznam žádostí o schválení
        List<Approval.ProcessSubmitRequest> submitRequests = new List<Approval.ProcessSubmitRequest>();
        
        // Pro každou načtenou rezervaci připravte žádost o schválení
        for (Rezervace__c reservation : reservations) {
            Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();
            // Nastavit komentář pro žádost o schválen
            submitRequest.setComments('Automaticky odesláno ke schválení');
            // Nastavit ID objektu, který má být schválen (v tomto případě ID rezervace)
            submitRequest.setObjectId(reservation.Id);
            // Přidat žádost do seznamu žádostí o schválení
            submitRequests.add(submitRequest);
        }
        
        // Proveďte žádosti o schválení
        List<Approval.ProcessResult> processResults = Approval.process(submitRequests);
    }
}