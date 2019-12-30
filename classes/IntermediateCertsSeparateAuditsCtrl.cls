/*******************************************************************************************************
 Name: IntermediateCertsSeparateAuditsCtrl 
 
 Dependencies: IntermediateCertsSeparateAudits VF page, IntermediateCertsSeparateAuditsCSV VF page, 
 IntermediateCertsSeparateAuditsCtrlTest 
 
 Description: 'Intermediate Certs's Separate Audits' reports on Intermediate certs which have their own audits.
 
              Filtered By:    

              CA Owner/Certificate Record Type equals Intermediate Certificate
              AND CA Owner/Certificate Owner not equal to <Fill in Cert Name>
              AND Revocation Status equals Not Revoked
              AND Mozilla Status for the root cert equals Included,Change Requested
              AND Audits Same as Parent equals False
              AND Valid To (GMT) greater than TODAY
              AND Technically Constrained equals False

              Columns: CA Owner, Parent Certificate Name, Certificate Name, SHA-256 Fingerprint, 
                       Valid From [GMT], Valid To [GMT], Standard Audit, Standard Audit Period End Date, 
                       BR Audit, BR Audit Period End Date

              Columns For the non-CSV version, SHA-256 fingerprints links to 
                      https://crt.sh/?q=<SHA256-Fingerprint>
 Instructions: None
   
 *******************************************************************************************************
 Revision History:
 
     3/7/2019 - Created new
     7/9/2019 - Added "Commnets" field
 ******************************************************************************************************/
 
public without sharing class IntermediateCertsSeparateAuditsCtrl {
    
    public List<Account> accountSoLst {get;set;}
 
    public IntermediateCertsSeparateAuditsCtrl(){
        String intermediateCertRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Intermediate Certificate').getRecordTypeId();
        
        accountSoLst =  [SELECT Parent.Name, Name, SHA_256_Fingerprint__c, Valid_From_YYYY_MMM_DD__c, Valid_To_YYYY_MMM_DD__c, 
                         CA_Owner__c, Standard_Audit__c, BR_Audit__c, Standard_Audit_Period_End_Date__c, BR_Audit_Period_End_Date__c, Comments__c
                         FROM  Account 
                         Where RecordTypeId =: intermediateCertRecordTypeId 
                         AND Name != '<Fill in Cert Name>' 
                         AND Revocation_Status__c = 'Not Revoked' 
                         AND Root_Cert_Id__r.Status__c In ('Included','Change Requested') 
                         AND Audits_Same_as_Parent__c = FALSE 
                         AND Valid_To_GMT__c > TODAY 
                         AND Technically_Constrained__c = FALSE
                         ORDER BY CA_Owner__c];
                                    
        // if we are generating a CSV file then we need to replace the double quotes in all text fields with null
        if(Test.IsRunningTest() || (ApexPages.currentPage().getUrl().contains('CSV') && accountSoLst !=null && accountSoLst.size() > 0))
        {
            for(Account accountSo : accountSoLst) {
                if(accountSo.CA_Owner__c !=null && accountSo.CA_Owner__c.length() > 0) 
                    accountSo.CA_Owner__c = accountSo.CA_Owner__c.replace('"',''); 
                if(accountSo.name !=null && accountSo.name.length() > 0) 
                    accountSo.name = accountSo.name.replace('"',''); 
                if(accountSo.parent.name !=null && accountSo.parent.name.length() > 0) 
                    accountSo.parent.name = accountSo.parent.name.replace('"','');  
                if(accountSo.Comments__c !=null && accountSo.Comments__c.length() > 0) 
                    accountSo.Comments__c = accountSo.Comments__c.replace('"','');    
            }  
        }
    }
    
    public String getCurrentDate() {
        Datetime cDT = System.now();
        string CurrentDate = cDT.format('MMMM d, yyyy');
        return CurrentDate;
    }
}