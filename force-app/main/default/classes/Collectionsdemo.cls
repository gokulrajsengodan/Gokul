public class Collectionsdemo{
    public static void listdemo(){
         list<string> namelist=new list<string>();
         namelist.add('rohit');
        namelist.add('dhawamn');
        namelist.add('kohli');
        namelist.add('Iyer');
        namelist.add('pant');
        system.debug('namelist :'+namelist);
        
         namelist.add(0,'dhoni');
       system.debug('add new name :'+namelist);
        namelist.set(1,'gill');
        system.debug('set new name :'+namelist);
       string name= namelist.get(0);
        system.debug('get value'+name);
        
        boolean is=namelist.contains('kohli');
       system.debug('is'+is);
        
        boolean ises=namelist.contains('king');
       system.debug('ises'+ises);
        namelist.remove(1);
        system.debug('namelist'+namelist);
        list<account>ash=new list<account>();
        ash=[select id,name from account limit 10];
        system.debug('size'+ash);
        account ac=ash.get(1);
        system.debug('first value'+ac);
                                          
    }
}