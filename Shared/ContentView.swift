//
//  ContentView.swift
//  Shared
//
//  Created by Andy Ibanez on 3/13/21.
//

import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    @StateObject var locationViewModel = LocationViewModel()
    
    var body: some View {
        switch locationViewModel.authorizationStatus {
        case .notDetermined:
            AnyView(RequestLocationView())
                .environmentObject(locationViewModel)
        case .restricted:
            ErrorView(errorText: "Location use is restricted.")
        case .denied:
            ErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
        case .authorizedAlways, .authorizedWhenInUse:
//            TrackingView()
//                .environmentObject(locationViewModel)
          MapView()
        default:
            Text("Unexpected status")
        }
    }
}

struct RequestLocationView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "location.circle")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            Button(action: {
                locationViewModel.requestPermission()
            }, label: {
                Label("Allow tracking", systemImage: "location")
            })
            .padding(10)
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Text("We need your permission to track you.")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}

struct ErrorView: View {
    var errorText: String
    
    var body: some View {
        VStack {
            Image(systemName: "xmark.octagon")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text(errorText)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct MapView:View{
  @StateObject var locationViewModel = LocationViewModel()
  @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.785834, longitude: -122.406417), latitudinalMeters: 1, longitudinalMeters: 1)
  @State var tracking : MapUserTrackingMode = .follow
  var body: some View {
//    Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
//      .edgesIgnoringSafeArea(.all)
    Map(coordinateRegion: $region, showsUserLocation: false, userTrackingMode: .constant(.follow), annotationItems: locationViewModel.pins){
      pin in
      MapPin(coordinate: CLLocationCoordinate2D(latitude: pin.location.coordinate.latitude, longitude: pin.location.coordinate.longitude), tint: .red)
    }
               .frame(width: 400, height: 300)
               .edgesIgnoringSafeArea(.all)

  }
}

struct TrackingView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    
    var body: some View {
        VStack {
            VStack {
                PairView(
                    leftText: "Latitude:",
                    rightText: String(coordinate?.latitude ?? 0)
                )
                PairView(
                    leftText: "Longitude:",
                    rightText: String(coordinate?.longitude ?? 0)
                )
                PairView(
                    leftText: "Altitude",
                    rightText: String(locationViewModel.lastSeenLocation?.altitude ?? 0)
                )
                PairView(
                    leftText: "Speed",
                    rightText: String(locationViewModel.lastSeenLocation?.speed ?? 0)
                )
                PairView(
                    leftText: "Country",
                    rightText: locationViewModel.currentPlacemark?.country ?? ""
                )
                PairView(leftText: "City", rightText: locationViewModel.currentPlacemark?.administrativeArea ?? ""
                )
            }
            .padding()
        }
    }
    
    var coordinate: CLLocationCoordinate2D? {
        locationViewModel.lastSeenLocation?.coordinate
    }
}

struct PairView: View {
    let leftText: String
    let rightText: String
    
    var body: some View {
        HStack {
            Text(leftText)
            Spacer()
            Text(rightText)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
