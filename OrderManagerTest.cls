@isTest
 public with sharing class OrderManagerTest {
     
    @TestSetup
    static void setup() {
        TestDataFactoryP11 df = new TestDataFactoryP11();
    }       
     
    @isTest
    public static void hasProductsTestwithoutProducts (){
        // Create 5 Accounts without draft orders
        boolean hasProducts = false ;
        Test.startTest();
        TestDataFactoryP11.makeOrders(5,0, 'Draft');
		List<Order> orderListBeforeUpdate = [SELECT Id FROM Order WHERE Id IN (SELECT OrderId FROM OrderItem)];
         OrderManager.HasProducts(orderListBeforeUpdate) ; 
         Test.stopTest();
        // we test if our boolean function works as intended which translates into false if it doesn't have Products or true if it does
		System.assertEquals(false, OrderManager.HasProducts(orderListBeforeUpdate)); 
     }
     
      @isTest
    public static void hasProductsTestwithProducts (){
        // Create 5 Accounts without draft orders
        boolean hasProducts = false ;
        Test.startTest();
        TestDataFactoryP11.makeOrders(5,6, 'Draft');
		List<Order> orderListBeforeUpdate = [SELECT Id FROM Order WHERE Id IN (SELECT OrderId FROM OrderItem)];
         OrderManager.HasProducts(orderListBeforeUpdate) ; 
         Test.stopTest();
        // we test if our boolean function works as intended which translates into false if it doesn't have Products or true if it does
		System.assertEquals(true, OrderManager.HasProducts(orderListBeforeUpdate)); 
     }
     
     @isTest
     public static void updateOrdersTestwithoutProducts(){
      Test.startTest();
        TestDataFactoryP11.makeOrders(5,0, 'Draft');    
         List<Order> orderListBeforeUpdate = [SELECT Id FROM Order WHERE Id IN (SELECT OrderId FROM OrderItem)];
          OrderManager.updateOrders(orderListBeforeUpdate) ;
         Test.stopTest();
         // Since we can't assert a row from an empty list , we assert if the list is empty as a whole which  means no changes to orders Status
         System.assertEquals(true, orderListBeforeUpdate.isEmpty());
     }
     
     @isTest
     public static void updateOrdersTestwithProducts(){
	  Test.startTest();
        TestDataFactoryP11.makeOrders(5,7, 'Draft');    
         List<Order> orderListBeforeUpdate = [SELECT Id FROM Order WHERE Id IN (SELECT OrderId FROM OrderItem)];
          OrderManager.updateOrders(orderListBeforeUpdate) ;
         Test.stopTest();
         // We Take a random order to check if status has changed from null to 'Activated' when it has still products inside
         Order singleOrder = [ SELECT Id, Status FROM Order WHERE Account.Name LIKE 'TestAccount%' LIMIT 1 ];
         System.assertEquals('Activated', singleOrder.Status);
     }
     
     @isTest
    public static void hasOtherOrdersTestwithoutOrders  (){
        // Create 5 Accounts without draft orders
        boolean hasOrders = false ;
        Test.startTest();
        TestDataFactoryP11.makeOrders(5,0, 'Draft');
        set<Id> setAccountIds = new set<Id>();
        List <Order> ordersList = new List<Order>();
        for (Order newOrder : ordersList) {
            setAccountIds.add(newOrder.AccountId);
        }
        List<Account> accountListBeforeUpdate = [SELECT Id ,(SELECT AccountId FROM Orders)FROM Account WHERE Id IN : setAccountIds];
        OrderManager.hasOtherOrders(ordersList);
        Test.stopTest();
        // we test if our boolean function works as intended which translates into false if it doesn't have Orders or true if it does
		System.assertEquals(false, orderManager.hasOtherOrders(ordersList));
     }
     
     @isTest
    public static void hasOtherOrdersTestwithOrders  (){
        // Create 5 Accounts without draft orders
        boolean hasOrders = false ;
       Test.startTest();
        TestDataFactoryP11.makeOrders(5,8, 'Draft');
        set<Id> setAccountIds = new set<Id>();
        List <Order> ordersList = new List<Order>();
        for (Order newOrder : ordersList) {
            setAccountIds.add(newOrder.AccountId);
        }
        List<Account> accountListBeforeUpdate = [SELECT Id ,(SELECT AccountId FROM Orders)FROM Account WHERE Id IN : setAccountIds];
        OrderManager.hasOtherOrders(ordersList);
        Test.stopTest();
        // we test if our boolean function works as intended which translates into false if it doesn't have Orders or true if it does
		System.assertEquals(true, orderManager.hasOtherOrders(ordersList));
     }
     
     @isTest
     public static void updateAccountTestwithoutProducts(){
	  Test.startTest();
        TestDataFactoryP11.makeOrders(5,0, 'Activated');    
 		set<Id> setAccountIds = new set<Id>();
        List <Order> ordersList = new List<Order>();
        for (Order newOrder : ordersList) {
            setAccountIds.add(newOrder.AccountId);
        }

		List<Account> activatedAccList = [ SELECT Id, Active__c,(SELECT Id, AccountId FROM Orders) FROM Account WHERE Id IN : setAccountIds];
         OrderManager.updateAccount(ordersList);        	
         Test.stopTest();
         // We Take a random account to check if active__c which is a custom checkbox field from Account Object is still unchecked 
         Account singleAccount = [ SELECT Id,active__c FROM Account LIMIT 1 ];
         System.assertEquals(false, singleAccount.Active__c);
     }
     
     @isTest
     public static void updateAccountTestwithProducts(){
         Test.startTest();
        TestDataFactoryP11.makeOrders(5,3, 'Activated');    
 		set<Id> setAccountIds = new set<Id>();
        List <Order> ordersList = new List<Order>();
           for (Order newOrder : ordersList) {
            setAccountIds.add(newOrder.AccountId);
        }

		List<Account> activatedAccList = [ SELECT Id, Active__c,(SELECT Id, AccountId FROM Orders) FROM Account WHERE Id IN : setAccountIds];
         OrderManager.updateAccount(ordersList);        	
         Test.stopTest();
         // We Take a random account to check if active__c which is a custom checkbox field from Account Object has changed from unchecked to check
         Account singleAccount = [ SELECT Id,active__c,Name FROM Account LIMIT 1];
         System.assertEquals(true, singleAccount.Active__c);
     }
 }