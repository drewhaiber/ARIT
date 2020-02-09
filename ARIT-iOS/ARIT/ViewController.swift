//
//  ViewController.swift
//  ARIT
//
//  Created by Bradley Klemick on 2/8/20.
//

import UIKit
import ARKit
import SceneKit
import CoreLocation
import MapKit

class ViewController: UIViewController, LNTouchDelegate {
    public static var instance: ViewController?
    public var imgBuildingSmall: UIImageView!
    public var lblBuildingAcronym: UILabel!
    public var lblBuildingName: UILabel!
    public var botWindowView: UIView!
    private let botWindowHeight: CGFloat = 200
    private var lastTouched: LocationAnnotationNode?
    private var sceneLocationView = SceneLocationView()
    private var points = [Waypoint]()
    
    func annotationNodeTouched(node: AnnotationNode) {
        for laNode in sceneLocationView.locationNodes {
            if let laNode = laNode as? LocationAnnotationNode,
                let point = laNode.waypoint {
                if laNode.annotationNode == node {
                    lblBuildingName.text = point.name
                    lblBuildingAcronym.text = point.acro
                    if let url = URL(string: point.imageUrl) {
                        let session = URLSession(configuration: .default)
                        session.dataTask(with: url) { (data, response, error) in
                            if let imageData = data {
                                let image = UIImage(data: imageData)
                                DispatchQueue.main.async {
                                    self.imgBuildingSmall.image = image
                                }
                            }
                        }.resume()
                    }
                    laNode.setExpanded(true)
                    lastTouched = laNode
                    updateBotWindow()
                }
            }
        }
    }
    
    func locationNodeTouched(node: LocationNode) {
    }
    
    func nothingTouched() {
        lastTouched?.setExpanded(false)
        lastTouched = nil
        updateBotWindow()
    }
    
    func updateBotWindow() {
        UIView.animate(withDuration: 0.6, animations: {() in
            self.botWindowView.frame.origin.y = UIScreen.main.bounds.size.height - (self.lastTouched != nil ? self.botWindowHeight: 0.0)
        })
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        ViewController.instance = self
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        botWindowView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: botWindowHeight))
        botWindowView.backgroundColor = UIColor.init(white: 0.1, alpha: 1.0)
        view.addSubview(botWindowView)
        
        lblBuildingName = UILabel(frame: CGRect(x: 16, y: 16, width: UIScreen.main.bounds.size.width - 32, height: 32))
        lblBuildingName.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.thin)
        lblBuildingAcronym = UILabel(frame: CGRect(x: 16, y: 44, width: UIScreen.main.bounds.size.width - 32, height: 32))
        lblBuildingAcronym.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        imgBuildingSmall = UIImageView(frame: CGRect(x: UIScreen.main.bounds.size.width - 128, y: 52, width: 112, height: 112))
        botWindowView.addSubview(lblBuildingName)
        botWindowView.addSubview(lblBuildingAcronym)
        botWindowView.addSubview(imgBuildingSmall)
        
        do {
            let jsonPath = Bundle.main.url(forResource: "partData", withExtension: "json")!
            let jsonData = try Data(contentsOf: jsonPath)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let json = json as? [[String: AnyObject]] {
                for jso in json {
                    if let properties = jso["properties"] as? [String: AnyObject] {
                        if let name = properties["name"] as? String,
                            let acro = properties["description"] as? String,
                            let imageUrl = properties["image"] as? String {
                            if let poly = jso["poly"] as? [[Double]] {
                                var polyCoords = [CLLocationCoordinate2D]()
                                for coords in poly {
                                    polyCoords.append(CLLocationCoordinate2DMake(coords[1], coords[0]))
                                }
                                points.append(Waypoint(polyCoords: polyCoords, name: name, acro: acro, imageUrl: imageUrl))
                            }
                        }
                    }
                }
            }
        } catch let error {
            print(error)
        }
        
        replaceAllPoints()
    }
    
    public func replaceAllPoints() {
        //let image = UIImage(named: "pin")!
        //let coordinate = CLLocationCoordinate2D(latitude: 43.085307, longitude: -77.671207)
        sceneLocationView.removeAllNodes()
        sceneLocationView.locationNodeTouchDelegate = self
        for point in points {
            let coordinate = CLLocationCoordinate2D(latitude: point.lat, longitude: point.lon)
            let location = CLLocation(coordinate: coordinate, altitude: 160)

            /*let layer = CATextLayer()
            layer.string = point.name
            layer.fontSize = 28.0
            layer.foregroundColor = UIColor.orange.cgColor
            layer.backgroundColor = UIColor.black.cgColor
            layer.alignmentMode = CATextLayerAlignmentMode.right
            layer.bounds = CGRect(x: 30, y: -50, width: 350, height: 90)*/
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 110))
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 90))
            let arrow = TriangleView(frame: CGRect(x: 120, y: 90, width: 60, height: 20))
            arrow.backgroundColor = UIColor.clear
            label.text = point.name
            label.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.bold)
            label.textAlignment = NSTextAlignment.center
            label.textColor = UIColor.orange
            label.numberOfLines = 0
            label.backgroundColor = UIColor.black
            label.adjustsFontSizeToFitWidth = true
            view.addSubview(label)
            view.addSubview(arrow)
            let annotationNode = LocationAnnotationNode(location: location, view: view)
            annotationNode.waypoint = point
            annotationNode.scalingScheme = ScalingScheme.linear(threshold: 1000)
            annotationNode.ignoreAltitude = true
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        }
    }

    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

      sceneLocationView.frame = view.bounds
    }
}

