public class EmailTemplateVisualforce {
	private final List<Account> accounts;

	public EmailTemplateVisualforce() {
		accounts = [select Name from Account where Name LIKE 'test_%'];
	}

	public List<Account> getTestAccounts() {
		return accounts;
	}
}