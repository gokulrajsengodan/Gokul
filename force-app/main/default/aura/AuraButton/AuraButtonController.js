({
	handleButton1 : function(component, event, helper) {

		component.set("v.message1",event.getSource().get('v.label'))
	},
    
   handleInputChange : function(component, event, helper) {
        console.log('Called the controller method')
        console.log(event.getSource().get('v.value'));
		component.set("v.message2",event.getSource().get('v.value'))
	}
})