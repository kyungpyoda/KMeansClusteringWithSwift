//
//  ViewController.swift
//  KMeansClusteringApp
//
//  Created by 홍경표 on 2020/11/19.
//

import UIKit

class ViewController: UIViewController {

    struct Vector {
        var lng: Double
        var lat: Double
    }
    let K_COUNT = 5
    let DATA_COUNT = 50
    var k = [Vector]()
    var center = [Vector]()
    var datas = [Vector]()
    
    @IBOutlet weak var board: UIView!
    @IBOutlet weak var centerBoard: UIView!
    
    private func makePointView(vector: Vector) -> UIView {
        let view = UIView(frame: CGRect(
            x: vector.lng,
            y: vector.lat,
            width: 5,
            height: 5
        ))
        view.backgroundColor = .white
        return view
    }
    private func makeClusterView(vector: Vector) -> UIView {
        let view = UIView(frame: CGRect(
            x: vector.lng,
            y: vector.lat,
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

    @IBAction func touchedGenerateButton(_ sender: Any) {
        datas.removeAll()
        k.removeAll()
        center.removeAll()
        board.subviews.forEach({
            $0.removeFromSuperview()
        })
        
        (0..<DATA_COUNT).forEach { _ in
            let rx = Double.random(in: 0...Double(board.frame.width))
            let ry = Double.random(in: 0...Double(board.frame.height))
            datas.append(Vector(lng: rx, lat: ry))
        }
        datas.forEach({
            board.addSubview(makePointView(vector: $0))
        })
        (0..<K_COUNT).forEach { i in
            center.append(datas[i])
        }
        centerBoard.subviews.forEach {
            $0.removeFromSuperview()
        }
        center.forEach({
            centerBoard.addSubview(makeClusterView(vector: $0))
        })
    }
    
    @IBAction func touchedContinue(_ sender: Any) {
        var temp = [[Vector]](repeating: [], count: K_COUNT)
        datas.forEach { d in
            var distances = [Double]()
            for c in center {
                let distance = (d.lat - c.lat) * (d.lat - c.lat) + (d.lng - c.lng) * (d.lng - c.lng)
                distances.append(distance)
            }
            let minDistance = distances.min()!
            let index = distances.firstIndex(of: minDistance)!
            temp[index].append(d)
        }
        
        center.removeAll()
        temp.forEach({ c in
            var sumX = 0.0
            var sumY = 0.0
            c.forEach({
                sumX += $0.lng
                sumY += $0.lat
            })
            let averageX = sumX / Double(c.count)
            let averageY = sumY / Double(c.count)
            center.append(Vector(lng: averageX, lat: averageY))
        })
        centerBoard.subviews.forEach {
            $0.removeFromSuperview()
        }
        center.forEach({
            centerBoard.addSubview(makeClusterView(vector: $0))
        })
    }
}

