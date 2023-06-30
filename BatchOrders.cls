public class BatchOrders implements Database.Batchable<sObject> {
  public Database.QueryLocator start (Database.BatchableContext bc) {
    // collect the batches of accounts with activated orders to be passed to execute
    String query = 'SELECT Id, Active__c,OwnerId, (SELECT Id FROM Orders WHERE Status = \'Activated\') FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status != \'Active\')' ;
    return Database.getQueryLocator(query);
  }
  public void execute(Database.BatchableContext bc, List<Account> scope) {
      List<Account> accsToUpdate = new List<Account>();
      
     List<Task> tasksToInsert = new List<Task>();
        for ( Account acc : scope){
            // Creating a reminder task for each retrieved account
            if(acc.Orders.size() == 0 && acc.Tasks.size() == 0){
               Task t = new Task();
           	   t.Subject = 'Call';
               t.Priority = 'Normal';
          	   t.Status = 'New';
         	   t.OwnerId = acc.OwnerId;
         	   t.WhatId = acc.Id;
               t.ActivityDate = System.today() + 5 ;
         	   tasksToInsert.add(t);
        }	
            }
    // Finally update list of accounts
    update scope;
  }
 public void finish(Database.BatchableContext bc) {
    // Nothing to do after the process
  }
}