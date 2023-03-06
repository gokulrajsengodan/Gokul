public class publishEvent {

    @AuraEnabled
    public static void publishEvent(String message) {
    POV_Platform_Event__e event = new POV_Platform_Event__e(Message__c = message);
 
    Database.SaveResult result = EventBus.publish(event);
 
    if (!result.isSuccess()) {
      for (Database.Error error : result.getErrors()) {
        System.debug('Error returned: ' +error.getStatusCode() +' - ' +error.getMessage());
      }
    }
  }
}