public class AccountcaseTriggerhandler {
    
    public void accountinsert(list<account>acclist){
        for(account acc:acclist){
            if(acc.Rating == 'Hot'){
                acc.Phone='12357';
            }else if(acc.Rating == 'cold'){
         acc.Phone='67890';
            }
        }
    }
    public void createcontact(list<account>acclist){
        for(account acc:acclist){
            if(acc.Rating=='hot'){
               contact con=new contact();
                con.LastName=acc.Name;
                con.Salutation='Mr.';
            }
        }
    }
}