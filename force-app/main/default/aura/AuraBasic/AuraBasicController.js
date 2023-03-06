({
	handleVariable : function(component, event, helper) {
		component.set("v.Var2","Values assgin from controller")
        var data = {'Name':'Gokul',
                    'Email':'gokulrajs691@gmail.com'}
        component.set("v.jsObject",data)
        component.set("v.userData",{'stringValue':'Test Aura from Apex','intValue':120})
	}
})