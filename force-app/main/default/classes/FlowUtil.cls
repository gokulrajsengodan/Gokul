public class FlowUtil {
    
    @InvocableMethod
    public static List<DataWrapper> returnObjectName(List<DataWrapper> wrapperList){
        for(DataWrapper wrapper : wrapperList){
            if(wrapper.methodName=='getObjectName')
                return new List<DataWrapper> {getObjectName(wrapper.recordId)};
        }
        return null;
    }
    
    public static DataWrapper getObjectName(Id recordId){
        String objectName = recordId.getSobjectType().getDescribe().getName();
        DataWrapper wrapper = new DataWrapper();
    	wrapper.returnValue = objectName;
        return wrapper;
    }
    
    public class DataWrapper {
        @InvocableVariable public String methodName;
        @InvocableVariable public ID recordId;
        @InvocableVariable public String returnValue;
    }
}