public class onlineclassapex {
    public id accountinsert(){
        account ac=new account();
        ac.name='apex online test record id return';
        ac.accountnumber='123456789';
        insert ac;
        return ac.id;
    }
}