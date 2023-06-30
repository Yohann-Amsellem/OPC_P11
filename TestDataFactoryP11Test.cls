@IsTest
public class TestDataFactoryP11Test {
    @isTest
    private static void makeOrdersTest() {
        // GIVEN
        // WHEN
        // Create 5 accounts with 5 draft orders each
        Test.startTest();
        TestDataFactoryP11 df = new TestDataFactoryP11();
        TestDataFactoryP11.makeOrders (5,10, 'Draft');
        
        // THEN
        // Get the list of orders and a random single order for assertion
		List<order> orderList = new List<order>();
        orderList = [SELECT Id, Account.Name FROM Order WHERE Account.Name LIKE 'TestAccount%'];
        Order singleOrder = [ SELECT Id, Account.Name, Status FROM Order WHERE Account.Name LIKE 'TestAccount%' LIMIT 1 ];
        
        // Get the list of accounts and a random single account for assertion
        List<account> accountList = new List<account>();
        accountList = [SELECT Id, Name FROM Account WHERE Name LIKE 'TestAccount%'];
     //   Account singleAccount = [ SELECT Id,active__c FROM Account WHERE Name LIKE 'TestAccount%' LIMIT 1 ];
        Test.stopTest();

        // Orders' status should be ordered
        System.assertEquals('Draft', singleOrder.status, 'Problem : status is not draft');
        // Orders' size should be 50 (5x10)
        System.assertEquals(50, orderList.size(),'Problem : number of orders created does not match');
        //Accounts' size should be 5
        System.assertEquals(5, accountList.size(), 'Problem : number of accounts created does not match');
        //Accounts' status should be null at start
     //   System.assertEquals(null, singleAccount.active__c, 'Problem : Account\'s status is active');

    }
    @isTest
    private static void makeOrdersTestWithActivatedOrder() {
        // Create 5 accounts with 3 activated orders each
         Test.startTest();
        TestDataFactoryP11 df = new TestDataFactoryP11();
        TestDataFactoryP11.makeOrders (5,3, 'Activated');
        
        // THEN
        // Get the list of orders and a random single order for assertion
		List<order> orderList = new List<order>();
        orderList = [SELECT Id, Account.Name FROM Order WHERE Account.Name LIKE 'TestAccount%'];
        Order singleOrder = [ SELECT Id, Account.Name, Status FROM Order WHERE Account.Name LIKE 'TestAccount%' LIMIT 1 ];
         Test.StopTest();

        // Orders' status should be Draft
        System.assertEquals('Activated', singleOrder.status, 'Problem : orders status is not activated');

    }
}