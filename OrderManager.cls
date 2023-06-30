public with sharing class OrderManager {
    
    
    public static boolean hasProducts(List<Order> ordersList) {
// OrderItem is API Name for Order Product Salesforce Standard Object
// Iterate over triggered Orders.
		 boolean hasProducts = false;
        for(Order newOrder : ordersList = [SELECT Id FROM Order WHERE Id IN (SELECT OrderId FROM OrderItem)]) {
          // we check if the request returns an empty list or not to determine if we should change boolean value
       		 if (ordersList.size() >= 0) {
                 hasProducts = true ;
        		}
            }
        return hasProducts ;
	}
    
    public static void updateOrders(List<Order> ordersList2) {
// OrderItem is API Name for Order Product Salesforce Standard Object
// Iterate over triggered Orders.
        for(Order newOrder : ordersList2 = [SELECT Id FROM Order WHERE Id IN (SELECT OrderId FROM OrderItem)]) {
          // we check if the request returns an empty list or not to determine if we should block status update
       		 if (ordersList2.size() <= 0) {
        		Trigger.oldMap.get(newOrder.Id).addError('Please add products in Order before changing status to Activated');
        		}
            else {
                NewOrder.status = 'Activated' ;
                
            }
   	 	}
      update ordersList2;
	}
    
    public static boolean hasOtherOrders(List <Order> OrdersList3) {
     	boolean hasOrders = false ;
        List<Account> accList = new List<Account>() ;
        // Get the Ids of the accounts concerned by the trigger with a for loop
         // set<Id> setAccountIds = new set<Id>();
      
        for(Account newAccount : accList = [SELECT Id , (SELECT AccountId FROM Orders) FROM Account]) {
		// Then iterate through all account's orders to check any other orders
            
           for(Order orders : newAccount.orders) {
                if (accList.size()>0)  {
                  hasOrders = true;
                }
      		}
        }
         return hasOrders;
    }
    
    public static void updateAccount(List<Order> OrdersList4){
        
        /*
        set<Id> setAccountIds = new set<Id>();
        List<Order>ordersList = new List<Order>();
        for (Order newOrder : ordersList) {
            setAccountIds.add(newOrder.AccountId);
        }
    }
*/
      List<Account> accountsToUpdate = new List<Account>();
	  List<Account> accounts = new List<Account>() ;
// Iterate over the Account records
for (Account acc : accounts = [SELECT Id, Active__c, (SELECT Id FROM Orders) FROM Account]) {
    acc.Active__c = true;
    // Check if the Account has no related Orders
    if (acc.Orders.isEmpty()) {
        // Update the Active__c field value
        acc.Active__c = false;
    }// Set the desired value (e.g., 'false') to update the checkbox field
    accountsToUpdate.add(acc); // Add the Account record to the list for update
    update accountsToUpdate;
}
}
}