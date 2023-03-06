public class apexonline {
    public account accountinsert(string acname,string acrating){
        account act=new account();
        act.name=acname;
        act.rating=acrating;
        
        insert act;
        return act;
}
}