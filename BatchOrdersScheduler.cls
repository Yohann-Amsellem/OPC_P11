global with sharing class BatchOrdersScheduler implements Schedulable {
  global void execute(SchedulableContext ctx) {
     BatchOrders batch = new BatchOrders();
    Id batchId = Database.executeBatch(batch);
  }
}