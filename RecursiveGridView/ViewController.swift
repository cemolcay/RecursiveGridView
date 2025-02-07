//
//  ViewController.swift
//  RecursiveGridView
//
//  Created by Cem Olcay on 2/7/25.
//

import UIKit

class GridItemView: UIView {
    let label = UILabel()
    
    init(number: Int) {
        super.init(frame: .zero)
        label.text = number.description
        label.textColor = .black
        label.textAlignment = .center
        addSubview(label)
        backgroundColor = UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }
}

class ViewController: UIViewController {
    let grid = RecursiveGridView()
    let viewCountLabel = UILabel()
    var viewCount = 3
    var gridViews = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UIStackView()
        layout.axis = .vertical
        layout.distribution = .fill
        layout.alignment = .fill
        layout.spacing = 8
        view.addSubview(layout)
        layout.translatesAutoresizingMaskIntoConstraints = false
        layout.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        layout.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        layout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        layout.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let controlStack = UIStackView()
        controlStack.axis = .horizontal
        controlStack.spacing = 8
        controlStack.alignment = .center
        controlStack.distribution = .fill
        viewCountLabel.text = "View count: \(viewCount)"
        controlStack.addArrangedSubview(viewCountLabel)
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 100
        stepper.value = Double(viewCount)
        stepper.addTarget(self, action: #selector(stepperValueChanged(sender:)), for: .valueChanged)
        controlStack.addArrangedSubview(stepper)
        
        layout.addArrangedSubview(grid)
        layout.addArrangedSubview(controlStack)
        
        controlStack.translatesAutoresizingMaskIntoConstraints = false
        controlStack.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        for _ in 0..<viewCount {
            gridViews.append(GridItemView(number: gridViews.count + 1))
        }
        
        grid.spacing = 1
        updateGrid()
    }
    
    func updateGrid() {
        grid.subviews.forEach({ $0.removeFromSuperview() })
        gridViews.forEach({ grid.addSubview($0) })
    }
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        // Update grid
        if viewCount < Int(sender.value) {
            gridViews.append(GridItemView(number: gridViews.count + 1))
        } else {
            gridViews.removeLast()
        }
        updateGrid()
        // Update title
        viewCount = Int(sender.value)
        viewCountLabel.text = "View count: \(viewCount)"
    }
}

