public class GoogleMapsCallout {
    public class Request {
        @InvocableVariable(label='Full Address') 
        public String address;
    }

    public class Response {
        @InvocableVariable(label='Latitude') 
        public Decimal lat;

        @InvocableVariable(label='Longitude') 
        public Decimal lng;
    }

    @InvocableMethod(label='Geocode Address using Google Maps')
    public static List<Response> geocode(List<Request> requests) {
        List<Response> results = new List<Response>();

        for (Request req : requests) {
            Response res = new Response();
            try {
                String encodedAddress = EncodingUtil.urlEncode(req.address, 'UTF-8');
                String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + 
                                  encodedAddress + 
                                  '&key=AIzaSyAaR3kC9h-izk5yP06u24HZzXkoxx1nn2s';

                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(endpoint);
                request.setMethod('GET');

                HttpResponse response = http.send(request);

                if (response.getStatusCode() == 200) {
                    Map<String, Object> json = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    List<Object> resultsList = (List<Object>) json.get('results');
                    if (!resultsList.isEmpty()) {
                        Map<String, Object> geometry = (Map<String, Object>) ((Map<String, Object>) resultsList[0]).get('geometry');
                        Map<String, Object> location = (Map<String, Object>) geometry.get('location');
                        res.lat = (Decimal) location.get('lat');
                        res.lng = (Decimal) location.get('lng');
                    }
                } else {
                    System.debug('Error from Geocoding API: ' + response.getBody());
                }
            } catch (Exception e) {
                System.debug('Exception during geocoding: ' + e.getMessage());
            }

            results.add(res);
        }

        return results;
    }
}
