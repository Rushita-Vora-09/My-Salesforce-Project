public class AccountOpportunityController {
    public List<Account> pagedAccounts { get; set; }
    public String selectedAccountId { get; set; }
    public String selectedAccountName { get; set; }
    public List<Opportunity> opportunities { get; set; }

    public Integer pageSize { get; set; }
    public Integer totalAccountRecords { get; set; }
    public Integer totalOpportunityRecords { get; set; }
    public Integer accountPageNumber { get; set; }
    public Integer opportunityPageNumber { get; set; }
    
    public Boolean showAccountList { get; set; }

    public AccountOpportunityController() {
        pageSize = 30;
        accountPageNumber = 1;
        opportunityPageNumber = 1;
        showAccountList = true;
        fetchAccounts();
    }

    // Fetch paginated accounts list
    public void fetchAccounts() {
        totalAccountRecords = [SELECT COUNT() FROM Account];

        pagedAccounts = [
            SELECT Id, Name 
            FROM Account 
            ORDER BY Name 
            LIMIT :pageSize OFFSET :((accountPageNumber - 1) * pageSize)
        ];
    }

// Fetch opportunities for selected account
    public void fetchOpportunities() {
        if (selectedAccountId != null) {
            selectedAccountName = [SELECT Name FROM Account WHERE Id = :selectedAccountId].Name;
            totalOpportunityRecords = [SELECT COUNT() FROM Opportunity WHERE AccountId = :selectedAccountId];

            opportunities = [
                SELECT Id, Name, StageName, Amount, CloseDate 
                FROM Opportunity 
                WHERE AccountId = :selectedAccountId 
                ORDER BY CloseDate DESC
                LIMIT :pageSize OFFSET :((opportunityPageNumber - 1) * pageSize)
            ];
            showAccountList = false;
        }
    }

    // Pagination for accounts
    public void nextAccountPage() {
        if ((accountPageNumber * pageSize) < totalAccountRecords) {
            accountPageNumber++;
            fetchAccounts();
        }
    }

    public void prevAccountPage() {
        if (accountPageNumber > 1) {
            accountPageNumber--;
            fetchAccounts();
        }
    }

    // Pagination for opportunities
    public void nextOpportunityPage() {
        if ((opportunityPageNumber * pageSize) < totalOpportunityRecords) {
            opportunityPageNumber++;
            fetchOpportunities();
        }
    }

    public void prevOpportunityPage() {
        if (opportunityPageNumber > 1) {
            opportunityPageNumber--;
            fetchOpportunities();
        }
    }

    public void backToAccounts() {
        showAccountList = true;
        selectedAccountId = null;
        selectedAccountName = null;
        opportunities.clear();
        opportunityPageNumber = 1; 
        fetchAccounts(); // Refresh the account list
    }

    // Get paginated accounts list
    public List<Account> getPagedAccounts() {
        return pagedAccounts;
    }
}