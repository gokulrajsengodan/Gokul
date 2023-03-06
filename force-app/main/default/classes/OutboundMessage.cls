public class OutboundMessage {

    public void sentMail(){
        messaging.SingleEmailMessage meg=new messaging.SingleEmailMessage();
        list<string>stlist=new list<string>();
        stlist.add('gokulrajs691@gmail.com');
        meg.setToAddresses(stlist);
        meg.setSubject('You see Except Things In Here');
        meg.setPlainTextBody('Hi Gokul');
        meg.setHtmlBody('<H1>Check</H1>');
        messaging.sendEmail(new messaging.SingleEmailMessage[] {meg});
    }
}