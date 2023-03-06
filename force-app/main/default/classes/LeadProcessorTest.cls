@isTest
public class LeadProcessorTest {
 @testSetup 
    static void setup() {
        List<Lead> leads = new List<Lead>();
        
        for (Integer i=0;i<200;i++) {
            Lead le=new Lead();
            le.LastName=le.LastName+i;
            le.Company='Lead';
            le.Status='Open Not Contacted';
            leads.add(le);
        }
        insert leads;
    }

    static testmethod void test() {  
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchId = Database.executeBatch(lp, 200);
        Test.stopTest();
        System.assertEquals(200, [select count() from lead where LeadSource = 'Dreamforce']);
    }
}