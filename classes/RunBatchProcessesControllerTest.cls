/*
    Test class for RunBatchProcessesController
*/
@isTest
public with sharing class RunBatchProcessesControllerTest {
    
    static testmethod void testRunALVBatch(){
        RunBatchProcessesController controller = new RunBatchProcessesController();
        controller.RunALVBatch();
    }
    
}