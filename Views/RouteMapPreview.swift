import SwiftUI
import MapKit

struct RouteMapPreview: View {
    let stops: [Stop]
    let vehicles: [VehiclePosition]

    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        Map(position: $position) {
            ForEach(stops) { stop in
                Annotation(stop.name, coordinate: stop.coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundStyle(Color.eshotPrimary)
                }
            }
            ForEach(vehicles) { vehicle in
                Annotation(vehicle.lineID, coordinate: CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)) {
                    Image(systemName: "bus.fill")
                        .foregroundStyle(.orange)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .onAppear {
            if let first = stops.first {
                position = .region(MKCoordinateRegion(
                    center: first.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                ))
            }
        }
    }
}
