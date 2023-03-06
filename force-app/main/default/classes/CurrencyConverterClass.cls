public class CurrencyConverterClass {
    
    public static Decimal convertcurrencyyoINR(Decimal eur){
        Decimal Inr = 0.0;
        HTTP http = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('http://api.exchangeratesapi.io/v1/latest?access_key=af5428c45bf2315d90e280acfbf20f12');
        req.setMethod('GET');
        
        HTTPResponse response = http.send(req);
        if(response.getStatusCode() == 200) {
            Map<String, Object> JSONBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            system.debug('JSONBody 1-->'+response.getBody());
            system.debug('JSONBody 2-->'+JSONBody);
            Map<String,Object> ratesMap = (Map<String,Object>) JSONBody.get('rates');
            System.debug('Received rates');
            Decimal conversationRate = (Decimal) ratesMap.get('INR');
            Inr = eur * conversationRate ;   
            System.debug('INR -->'+Inr);
        }
        return Inr;    
    }
}