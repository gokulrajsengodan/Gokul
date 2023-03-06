@isTest
public class FlowUtilTest {
	@isTest
    public static void testReturnObjectName(){
        list<FlowUtil.DataWrapper> dataList = new list<FlowUtil.DataWrapper>();
        FlowUtil.DataWrapper data = new FlowUtil.DataWrapper();
       
        data.recordId='a0G8M000000DAdtUAG';
        data.methodName='getObjectName';
        dataList.add(data);
        FlowUtil.returnObjectName(dataList);
    }
}