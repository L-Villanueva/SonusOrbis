//
//  ClusteredMapAppKitView.swift
//  Orbis Sonus
//
//  Created by Codex on 8/5/26.
//
#if os(macOS)
import SwiftUI
import MapKit
import AppKit

struct ClusteredMapAppKitView: NSViewRepresentable {
    
    @Binding var registros: [Registro]
    @Binding var selectedPlace: Registro?
    @Binding var mapStyleSatellite: Bool
    
    func makeNSView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "marker")
        return map
    }
    
    func updateNSView(_ map: MKMapView, context: Context) {
        map.mapType = mapStyleSatellite ? .hybridFlyover : .standard
        
        map.removeAnnotations(map.annotations)
        
        let annotations = registros.compactMap { place -> CustomAnnotation? in
            guard place.location != nil else { return nil }
            return CustomAnnotation(place: place)
        }
        
        map.addAnnotations(annotations)
        
        if !context.coordinator.hasCentered, !annotations.isEmpty {
            map.showAnnotations(annotations, animated: false)
            context.coordinator.hasCentered = true
        }
    }
    
    func makeCoordinator() -> MacCoordinator {
        MacCoordinator(self)
    }
}

final class MacCoordinator: NSObject, MKMapViewDelegate {
    
    var parent: ClusteredMapAppKitView
    var hasCentered = false
    
    init(_ parent: ClusteredMapAppKitView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let cluster = view.annotation as? MKClusterAnnotation {
            mapView.showAnnotations(cluster.memberAnnotations, animated: true)
        } else {
            self.parent.selectedPlace = (view.annotation as! CustomAnnotation).place
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
            view.image = resizedImage(resource: icon, targetSize: CGSize(width: 40, height: 55))
        }
        
        view.centerOffset = CGPoint(x: 0, y: -20)
        
        return view
    }
    
    private func resizedImage(resource: ImageResource, targetSize: NSSize) -> NSImage? {
        let image = NSImage(resource: resource)
        let resized = NSImage(size: targetSize)
        
        resized.lockFocus()
        image.draw(in: NSRect(origin: .zero, size: targetSize),
                   from: NSRect(origin: .zero, size: image.size),
                   operation: .copy,
                   fraction: 1.0)
        resized.unlockFocus()
        
        return resized
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
#endif
