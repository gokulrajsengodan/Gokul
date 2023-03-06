trigger updatephone on Account (before insert,before update) {
    for(account ac:trigger.new)
    {
         
        if(ac.phone !=trigger.oldmap.get(ac.id).phone){
            ac.phone=ac.name+ac.phone;
        }
        
        Contact con=new Contact();
            con.AccountId=ac.id;
            con.LastName=ac.Name;
            con.Description='pink';
        insert con;
    
    }
}