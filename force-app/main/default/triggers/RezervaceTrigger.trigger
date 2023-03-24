trigger RezervaceTrigger on Rezervace__c (before insert, after insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            RezervaceTriggerHelper.automaticallySendFoApproval(Trigger.New);
        }
    }
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            RezervaceTriggerHelper.validateCapacity(Trigger.New);
        }
    }
}