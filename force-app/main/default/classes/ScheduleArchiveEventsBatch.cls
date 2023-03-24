// Tato třída implementuje Schedulable rozhraní, které je nutné pro naplánované úlohy v Salesforce
global class ScheduleArchiveEventsBatch implements Schedulable {
    // Metoda execute je vyžadována rozhraním Schedulable a je automaticky zavolána, když je naplánovaná úloha spuštěna
    global void execute(SchedulableContext SC) {
        // Vytvoříme novou instanci třídy ArchiveEventsBatch, která obsahuje naši logiku pro archivaci událostí
        ArchiveEventsBatch batch = new ArchiveEventsBatch();
        // Spustíme naši batchovou úlohu pomocí metody Database.executeBatch
        Database.executeBatch(batch);
    }
}