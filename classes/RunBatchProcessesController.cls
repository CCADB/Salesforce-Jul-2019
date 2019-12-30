/*
    Creating Common controller to run any batch processes.
*/
public with sharing class RunBatchProcessesController {
    
    public RunBatchProcessesController(){
        
    }
    
    public void RunALVBatch(){
        RunALVForInterCertsBatch batch = new RunALVForInterCertsBatch('');
        Database.executebatch(batch,1);
    }


}