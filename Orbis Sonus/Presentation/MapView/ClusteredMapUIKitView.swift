//
//  ClusteredMapUIKitView.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 6/4/26.
//

import SwiftUI
import UIKit
import MapKit

struct ClusteredMapUIKitView: UIViewRepresentable {
    
    @Binding var registros: [Registro]
    @Binding var selectedPlace: Registro?
    @Binding var mapStyleSatellite: Bool
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        if #available(iOS 13.0, *) { map.overrideUserInterfaceStyle = .dark }
        map.overrideUserInterfaceStyle = .light
        map.delegate = context.coordinator
        map.tintColor = .systemBlue
        map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "marker")
        
        return map
    }
    func updateUIView(_ map: MKMapView, context: Context) {
        
        // 👇 CAMBIO DE ESTILO
        map.mapType = mapStyleSatellite ? .hybridFlyover : .standard
        
        map.removeAnnotations(map.annotations)
        
        let annotations = registros.compactMap { place -> CustomAnnotation? in
            guard let location = place.location else { return nil }
            return CustomAnnotation(place: place)
        }
        
        map.addAnnotations(annotations)
        
        if !context.coordinator.hasCentered, !annotations.isEmpty {
            map.showAnnotations(annotations, animated: false)
            context.coordinator.hasCentered = true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, selectedPlace: $selectedPlace)
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    
    var parent: ClusteredMapUIKitView
    var selectedPlaceBinding: Binding<Registro?>
    var hasCentered = false   // 👈 clave
    
    init(_ parent: ClusteredMapUIKitView, selectedPlace: Binding<Registro?>) {
        self.parent = parent
        self.selectedPlaceBinding = selectedPlace
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let cluster = view.annotation as? MKClusterAnnotation {
            mapView.showAnnotations(cluster.memberAnnotations, animated: true)
            return
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if let cluster = annotation as? MKClusterAnnotation {
            let view = MKMarkerAnnotationView(annotation: cluster, reuseIdentifier: "cluster")
            view.markerTintColor = .systemBlue
            view.glyphText = "\(cluster.memberAnnotations.count)"
            return view
        }
        
        guard let annotation = annotation as? CustomAnnotation else { return nil }
        
        let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "marker")
        view.clusteringIdentifier = "cluster"
        
        if let icon = annotation.place.type.icon {
            view.image = resizedImage(resource: icon, targetSize: CGSize(width: 40, height: 40))
        }
        
        // 👇 clave para que “pinche” bien en el mapa
        view.centerOffset = CGPoint(x: 0, y: -20)
        view.canShowCallout = true
        
        let button = UIButton(type: .detailDisclosure)
        view.rightCalloutAccessoryView = button
        
        return view
    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        guard let annotation = view.annotation as? CustomAnnotation else { return }
        
        parent.selectedPlace = annotation.place
    }
    
    func resizedImage(resource: ImageResource, targetSize: CGSize) -> UIImage? {
        let image = UIImage(resource: resource)
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            
            let imageSize = image.size
            
            let widthRatio = targetSize.width / imageSize.width
            let heightRatio = targetSize.height / imageSize.height
            
            let scaleFactor = min(widthRatio, heightRatio) // 👈 clave
            
            let scaledSize = CGSize(
                width: imageSize.width * scaleFactor,
                height: imageSize.height * scaleFactor
            )
            
            let origin = CGPoint(
                x: (targetSize.width - scaledSize.width) / 2,
                y: (targetSize.height - scaledSize.height) / 2
            )
            
            image.draw(in: CGRect(origin: origin, size: scaledSize))
        }
    }
}

class CustomAnnotation: NSObject, MKAnnotation {
    let place: Registro
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(place: Registro) {
        self.place = place
        self.coordinate = place.location!
        self.title = place.name
    }
}
