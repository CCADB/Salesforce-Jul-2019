/*******************************************************************************************************
 Name: IncludedCACertificateReportCtlrForMSFT

 Dependencies:  IncludedCACertificateReportCtlrForMSFT controller class, IncludedCACertificateReportTestForMSFT
 test class, IncludedCACertificateReportForMSFT vf page, IncludedCACertificateReportForMSFTCSV  vf page,
 IncludedCACertificateReportForMSFTCSVPEM  vf page

 Description: This is a test class for controller IncludedCACertificateReportCtlrForMSFT which
 generates list all root certificates included by Microsoft.
 
 Instructions: None   
 *******************************************************************************************************
 Revision History:
 
      8/16/2016 - Created new class
 ******************************************************************************************************/

@isTest 
public class IncludedCACertificateReportTestForMSFT{

    static testMethod void validateTest() {
        PageReference pref = Page.IncludedCACertificateReportForMSFTCSV;
        Test.setCurrentPage(pref);
        
        Account caOwnerAcc = TestUtils.getCAOwner();
        insert caOwnerAcc;
        
        Account childAccount = TestUtils.getRootCertificate(caOwnerAcc.id);
        childAccount.Microsoft_Status__c = 'Included';
        insert childAccount;
        
        IncludedCACertificateReportCtlrForMSFT certs = new IncludedCACertificateReportCtlrForMSFT();
        certs.getCurrentDate();
    }
}