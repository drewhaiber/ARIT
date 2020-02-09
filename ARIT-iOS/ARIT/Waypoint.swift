//
//  Waypoint.swift
//  ARIT
//
//  Created by Bradley Klemick on 2/9/20.
//

import CoreLocation

public struct Waypoint {
    var lat: Double
    var lon: Double
    var polyCoords: [CLLocationCoordinate2D]
    var name: String
    var acro: String
    var imageUrl: String
    
    init(polyCoords: [CLLocationCoordinate2D], name: String, acro: String, imageUrl: String) {
        self.polyCoords = polyCoords
        self.name = name
        self.acro = acro
        self.imageUrl = imageUrl
        var lat = 0.0
        var lon = 0.0
        for coord in polyCoords {
            lat += coord.latitude
            lon += coord.longitude
        }
        self.lat = lat / Double(polyCoords.count)
        self.lon = lon / Double(polyCoords.count)
    }
}

