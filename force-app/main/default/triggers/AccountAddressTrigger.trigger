trigger AccountAddressTrigger on Account (before insert,before update) {
   
for(account ac:trigger.new)
{
            if(ac.Match_Billing_Address__c ==true && ac.BillingPostalCode!=null){
                ac.ShippingPostalCode=ac.BillingPostalCode;
                
            }
     
        }
}