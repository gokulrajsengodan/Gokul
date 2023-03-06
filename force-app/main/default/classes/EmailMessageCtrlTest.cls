@isTest
public class EmailMessageCtrlTest {

    static testMethod void sendMailMethodTest() {
        EmailMessageCtrl.getEmailTempaltes();
        List<EmailMessageCtrl.RecordWrapper> recList = new List<EmailMessageCtrl.RecordWrapper>();
        EmailMessageCtrl.RecordWrapper rec = new EmailMessageCtrl.RecordWrapper();
        rec.email = 'test@gmail.com';
        rec.name = 'test';
        recList.add(rec);
        EmailMessageCtrl.sendMailMethod(JSON.serialize(recList), 'Test','Test','', '', '');
    }
    static testMethod void sendMailMethodTest1() {
        EmailMessageCtrl.getEmailTempaltes();
        List<EmailMessageCtrl.RecordWrapper> recList = new List<EmailMessageCtrl.RecordWrapper>();
        EmailMessageCtrl.RecordWrapper rec = new EmailMessageCtrl.RecordWrapper();
        rec.email = 'test@gmail.com';
        rec.name = 'test';
        recList.add(rec);
        EmailMessageCtrl.RecordWrapper rec1 = new EmailMessageCtrl.RecordWrapper();
        rec1.email = 'test1@gmail.com';
        rec1.name = 'test 1';
        recList.add(rec1);
        EmailMessageCtrl.sendMailMethod(JSON.serialize(recList), 'Test','Test','', '', '');
    }
}