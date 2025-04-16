@IsTest
private class GoogleMapsCalloutTest {
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"results":[{"geometry":{"location":{"lat":37.4224764,"lng":-122.0842499}}}]}');
            return res;
        }
    }

    @IsTest
    static void testGeocodeCallout() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        GoogleMapsCallout.Request input = new GoogleMapsCallout.Request();
        input.address = '1600 Amphitheatre Parkway, Mountain View, CA';

        List<GoogleMapsCallout.Request> inputs = new List<GoogleMapsCallout.Request>{ input };
        List<GoogleMapsCallout.Response> outputs = GoogleMapsCallout.geocode(inputs);

        System.assertEquals(1, outputs.size());
        System.assertEquals(37.4224764, outputs[0].lat);
        System.assertEquals(-122.0842499, outputs[0].lng);
    }
}
