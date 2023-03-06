public class RandomContactFactory {

    public static List <Contact> generateRandomContacts(Integer numCont, String conLstName) {
        List<Contact> listContact = new List<Contact>();
        
        for (Integer i=0; i < numCont; i++ ){
            Contact con = new Contact(FirstName='Test' +i,LastName='conLstName');
            listContact.add(con);
        }
        return listContact;
	}
}