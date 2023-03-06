public class NewCaseListController {
    
    public List<Case> getNewCases() {

        return [select Id,CaseNumber from Case where Status = 'New'];
        
    }
}