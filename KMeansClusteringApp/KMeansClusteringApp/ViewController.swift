//
//  ViewController.swift
//  KMeansClusteringApp
//
//  Created by 홍경표 on 2020/11/19.
//

import UIKit

class ViewController: UIViewController {

    struct Vertex {
        var lng: Double
        var lat: Double
        var centroidIndex: Int = -1
        func distanceTo(_ vertex: Vertex) -> Double {
            return sqrt((lat - vertex.lat) * (lat - vertex.lat) + (lng - vertex.lng) * (lng - vertex.lng))
        }
        static func centroid(of vertexs: [Vertex]) -> Vertex {
            var sumX = 0.0
            var sumY = 0.0
            vertexs.forEach { v in
                sumX += v.lng
                sumY += v.lat
            }
            let centerX = sumX / Double(vertexs.count)
            let centerY = sumY / Double(vertexs.count)
            return Vertex(lng: centerX, lat: centerY)
        }
        lazy var pointView: UIView = {
            let view = UIView()
            view.frame.origin.x = CGFloat(lng)
            view.frame.origin.y = CGFloat(lat)
            view.frame.size.width = 5
            view.frame.size.height = 5
            view.backgroundColor = .white
            return view
        }()
    }
    let K_COUNT = 5
    let DATA_COUNT = 50
    var k: [[Vertex]] = [[]]
    var centroids = [Vertex]()
    var datas = [Vertex]()
    
    @IBOutlet weak var board: UIView!
    @IBOutlet weak var centerBoard: UIView!
    
    private func makePointView(vertex: Vertex) -> UIView {
        let view = UIView(frame: CGRect(
            x: vertex.lng,
            y: vertex.lat,
            width: 5,
            height: 5
        ))
        view.backgroundColor = .white
        return view
    }
    private func makeClusterView(vertex: Vertex) -> UIView {
        let view = UIView(frame: CGRect(
            x: vertex.lng,
            y: vertex.lat,
            width: 15,
            height: 15
        ))
        view.backgroundColor = .red
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        board.layer.borderWidth = 1
        board.layer.borderColor = UIColor.black.cgColor
        
    }

    @IBAction func touchedClustering(_ sender: Any) {
        initAndClustering()
    }
    func initAndClustering() {
        datas.removeAll()
        k.removeAll()
        centroids.removeAll()
        board.subviews.forEach({
            $0.removeFromSuperview()
        })
        
        (0..<DATA_COUNT).forEach { _ in
            let rx = Double.random(in: 0...Double(board.frame.width))
            let ry = Double.random(in: 0...Double(board.frame.height))
            datas.append(Vertex(lng: rx, lat: ry))
        }
        for i in (0..<datas.count) {
            board.addSubview(datas[i].pointView)
        }
        (0..<K_COUNT).forEach { i in
            centroids.append(datas[i])
        }
        var flag = true
        while flag {
            flag = false
            var temp = [[Vertex]](repeating: [], count: K_COUNT)
            for i in (0..<datas.count) {
                var minDistance = Double.greatestFiniteMagnitude
                var indexOfNearest = -1
                for (index, centroid) in centroids.enumerated() {
                    let distance = datas[i].distanceTo(centroid)
                    if distance < minDistance {
                        minDistance = distance
                        indexOfNearest = index
                    }
                }
                guard indexOfNearest != -1 else { continue }
                if datas[i].centroidIndex != indexOfNearest {
                    flag = true
                }
                datas[i].centroidIndex = indexOfNearest
                
                temp[indexOfNearest].append(datas[i])
            }
            
            centroids.removeAll()
            temp.forEach({ vertexs in
                let centroid = Vertex.centroid(of: vertexs)
                centroids.append(centroid)
            })
            print("calculating")
        }
        print("end")
        centerBoard.subviews.forEach {
            $0.removeFromSuperview()
        }
        centroids.forEach({
            centerBoard.addSubview(makeClusterView(vertex: $0))
        })
        
    }
    @IBAction func touchedAnimate(_ sender: Any) {
        for i in (0..<datas.count) {
            UIView.animate(withDuration: 1, animations: {
                self.datas[i].pointView.transform = CGAffineTransform(translationX: CGFloat(self.centroids[self.datas[i].centroidIndex].lng) - self.datas[i].pointView.frame.origin.x, y: CGFloat(self.centroids[self.datas[i].centroidIndex].lat) - self.datas[i].pointView.frame.origin.y)
            })
        }
    }
}

