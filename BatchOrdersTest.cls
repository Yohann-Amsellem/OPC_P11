@isTest
private class BatchOrdersTest {
  @TestSetup
  static void setup() {
    TestDataFactoryP11 df = new TestDataFactoryP11();
  }
  @isTest
  static void testBatchOrdersWithOrdersOrTasks() {
    // Create 5 accounts with 3 orders for each of them.
    Test.startTest();
    TestDataFactoryP11.makeOrders(5, 3, 'Draft');
    BatchOrders batch = new BatchOrders();
    Id batchId = Database.executeBatch(batch);
    Test.stopTest();
/*
  	 Account testAccountAfterUpdate = [SELECT Id FROM Account WHERE Name LIKE 'TestAccount%'];

     Task TaskafterUpdate = [SELECT Id,Priority,Subject,Status FROM TASK WHERE WhatId = :testAccountAfterUpdate.Id LIMIT 1];
      
		System.assertEquals('Normal', TaskafterUpdate.Priority);
        System.assertEquals('Call', TaskafterUpdate.Subject);
        System.assertEquals('New', TaskafterUpdate.Status);
*/
      
      
   List<Task> tasks =
[SELECT Id,
       WhatId,
 	   Priority,
 		Subject,
 		Status,
       TypeOf What
           WHEN Account THEN Name, OwnerId
       END
  FROM Task
 WHERE WhatId In (SELECT Id
                    FROM Account)];


// Perform assertions on each Task record
	for (Task task : tasks) {  
 System.assertEquals('Normal', task.Priority);
 System.assertEquals('New', task.Status);
 System.assertEquals('Call', task.Subject);
	}
  }
    
     @isTest
  static void testBatchOrdersWithoutOrdersNorTasks() {
    // Create 5 accounts without orders for any of them.
    Test.startTest();
    TestDataFactoryP11.makeOrders(5, 0, 'Draft');
    BatchOrders batch = new BatchOrders();
    Id batchId = Database.executeBatch(batch);
    Test.stopTest();

   List<Task> tasks =
[SELECT Id,
       WhatId,
 	   Priority,
 		Subject,
 		Status,
       TypeOf What
           WHEN Account THEN Name, OwnerId
       END
  FROM Task
 WHERE WhatId In (SELECT Id
                    FROM Account)];


// Perform assertions on each Task record
	for (Task task : tasks) {  
 System.assertEquals('Normal', task.Priority);
 System.assertEquals('New', task.Status);
 System.assertEquals('Call', task.Subject);
	}
  }
}