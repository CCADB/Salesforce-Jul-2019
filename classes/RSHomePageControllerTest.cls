/*******************************************************************************************************
 Name: RSHomePageControllerTest

 Dependencies: RSHomePageController controller class, RSHomePage vf page, RSHomePageControllerTest test class

 Description: This is a test class for Mozilla's Root Store home page. The program generates
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
 
     7/8/2019 - Created new class
 ******************************************************************************************************/
 
@isTest
public with sharing class RSHomePageControllerTest {
    
    static testmethod void TestRSHomepage() {
        Lead lead = new Lead(LastName = 'Test Lead',Company = 'Test Company', Email = 'test@gmail.com');
        insert lead;
        
        Account acc = TestUtils.getCAOwner();
        insert acc;
        
        Case caseSO = TestUtils.getCase(acc.Id);
        caseSO.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CA Audit Update Request').getRecordTypeId();
        insert caseSO;
         
        // create a ROOT CA
        Account rootCA = TestUtils.getRootCertificate(acc.Id); 
        rootCa.X_509_Certificate_PEM__c = 'abc';
        rootCa.Status__c = 'Included';
        rootCa.Trust_Bits__c = 'Websites';
        rootCa.Subject_SPKI_SHA256__c = 'C90FBC2664485F6D3175055A45EF10D2EB6E6C7E027DF1A1D526458C42F42696';
        insert rootCa;
        
        Test.startTest(); 
        
        // create intermediate CA
        Account testAccount = TestUtils.getIntermediateCertificate(rootCa.Id);
        testAccount.X_509_Certificate_PEM__c = 'abc';
        testAccount.Subject_SPKI_SHA256__c = 'C90FBC2664485F6D3175055A45EF10D2EB6E6C7E027DF1A1D526458C42F42696';
        testAccount.Extended_Key_Usage__c = 'ExtKeyUsageEmailProtection,ExtKeyUsageClientAuth';
        insert testAccount; 
        
        RSHomePageController controller = new RSHomePageController ();
        
        Test.stopTest(); 
    }
    
}