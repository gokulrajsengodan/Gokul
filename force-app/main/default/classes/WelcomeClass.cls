/*
   call in the workbench --> /services/apexrest/v1/Welcome
 */

@RestResource(urlMapping='/v1/Welcome/*')
global with sharing class WelcomeClass {
    
    
    global final static string Welcome_Message = 'Welcome to integration course';
    
    @httpGet
    global static string greetingMessage(){
        return Welcome_Message;
    }
    
    @httpPost
    global static string postGreetingMessage(){
        return Welcome_Message + ' Post Method';
    }
    
    @httpPatch
    global static string patchGreetingMessage(){
        return Welcome_Message + ' Patch Method';
    }

}