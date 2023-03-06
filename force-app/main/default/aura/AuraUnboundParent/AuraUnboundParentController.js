({
	handleChange : function(component, event, helper) {
        console.log('Old Value -->'+event.getParam('oldValue'))
        console.log('New Value -->'+event.getParam('value'))
	},
    	handleClick : function(component, event, helper) {
		component.set("v.parentVar","Updated Parent Value")
	}

})