public class apexonlines {
    public static Account  accountinsert(string acname,string acrating)
    {
        Account act=new Account();
        act.name=acname;
        act.rating=acrating;
        
        insert act;
        system.debug('Account -->'+act);
        return act;
    }

    }