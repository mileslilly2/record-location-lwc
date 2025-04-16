import { LightningElement, api } from 'lwc';
import getRecordLocation from '@salesforce/apex/RecordLocationController.getRecordLocation';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import LEAFLET from '@salesforce/resourceUrl/leaflet';

export default class RecordMap extends LightningElement {
    @api recordId;
    leafletInitialized = false;

    renderedCallback() {
        if (this.leafletInitialized) return;
        this.leafletInitialized = true;

        Promise.all([
            loadScript(this, LEAFLET + '/leaflet.js'),
            loadStyle(this, LEAFLET + '/leaflet.css')
        ])
        .then(() => this.initMap())
        .catch(error => {
            console.error('Leaflet load error:', error);
        });
    }

    initMap() {
        console.log('🧭 initMap called');
        getRecordLocation({ recordId: this.recordId })
            .then(result => {
                console.log('📡 Location result:', result);
                const lat = parseFloat(result.lat);
                const lng = parseFloat(result.lng);
    
                if (isNaN(lat) || isNaN(lng)) {
                    console.warn('⚠️ Invalid coordinates:', result);
                    return;
                }
    
                const map = L.map(this.template.querySelector('.map')).setView([lat, lng], 13);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '© OpenStreetMap contributors'
                }).addTo(map);
    
                L.marker([lat, lng]).addTo(map);
            })
            .catch(error => {
                console.error('🔥 Error fetching location:', error);
            });
    }
    
}
