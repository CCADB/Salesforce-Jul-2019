/*******************************************************************************************************
 Name: RSHomePageController

 Dependencies: RSHomePageController controller class, RSHomePage vf page, RSHomePageControllerTest test class

 Description: This is Mozill's Root Store's Task List report (added to home page). It generates
 various reports wih record count for the Root Store. Detail report is only displayed when the 
 record count is greater than 1.
    
    There are 6 sections showing ...
    
    1) Open Leads 
    2) Audit Cases which are updated by CA in Last 30 days
    3) Inclusion Cases which are updated by CA in last 30 days.
    4) Audit Data Integrity (which linked to vf page)
    5) Verify updated Audits
    6) Verify Revoked Certst   

 Instructions: Add the VF page to Root Store's home page
 *******************************************************************************************************
 Revision History:
 
     7/2/2019 - Created new class
 ******************************************************************************************************/
 
public with sharing class RSHomePageController {
    
    public List<Lead> lstOpenLeads {get; set;}
    public List<Case> lstAuditCases {get; set;}
    public List<Case> lstInclusionCases {get; set;}   
    public List<Account> lstVerifyUpdatedAudits {get; set;}
    public List<Account> lstVerifyRevokedCerts {get; set;}
    
    public RSHomePageController(){
    
        lstOpenLeads = new List<Lead>([select Id,Name,Website,Company,Email,Organization_Type__c,CP_CPS_document_URLs__c from Lead 
                    Where Status != 'Converted' Order by Name]);
        
        List<User> lstCAUsers = new List<User>([select Id from User Where ContactID != null]);
        
        lstAuditCases = new List<Case>([select ID,CaseNumber,AccountId, Account.Name,Status_Summary__c,Request_Status__c,
                        Case_Assigned_To__c,Case_Assigned_To__r.Name, LastModifiedDate, LastModifiedById, LastModifiedBy.Name
                        from Case Where RecordType.Name = 'CA Audit Update Request' AND LastModifiedById =: lstCAUsers
                        AND LastModifiedDate = LAST_N_DAYS:30 and Request_Status__c != 'Complete' Order by CaseNumber,AccountId]);
                        
        lstInclusionCases = new List<Case>([select ID,CaseNumber,AccountId, Account.Name,Status_Summary__c,Request_Status__c,
                        Case_Assigned_To__c,Case_Assigned_To__r.Name, LastModifiedDate, LastModifiedById, LastModifiedBy.Name
                        from Case Where RecordType.Name = 'CA Root Inclusion Request' AND LastModifiedById =: lstCAUsers
                        AND LastModifiedDate = LAST_N_DAYS:30 and Request_Status__c != 'Complete' Order by CaseNumber,AccountId]);
        
        lstVerifyUpdatedAudits = new List<Account>([select Id,Name,Standard_Audit_Statement_Date__c,Mozilla_Verified_Audit_Date__c,
                        Removal_Bug_No_or_Date__c,Comments_by_Mozilla_on_Root__c,Comments__c from Account Where RecordType.Name = 'Root Certificate' AND 
                        Status__c in ('Included','Changed Requested') AND Audit_Date_Same__c = false
                        Order by Parent.Name,Name]);
                        
        lstVerifyRevokedCerts = new List<Account>([select Id,Name,CA_Owner__c,Certificate_Name__c,Valid_From_GMT__c,
                        Valid_To_GMT__c,Comments__c,CRL_URL_s__c,Certificate_Serial_Number__c,SHA_256_Fingerprint__c from Account Where 
                        RecordType.Name = 'Intermediate Certificate' AND 
                        Revocation_Status__c = 'Revoked' AND OneCRL_Status__c not in ('Ready to Add','Added to OneCRL','Cert Expired') 
                        AND CA_Owner_Mozilla_Status__c in ('Included','Changed Requested')
                        Order by CA_Owner__c,Name]);
    }
}