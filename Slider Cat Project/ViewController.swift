//
//  ViewController.swift
//  Slider Cat Project
//
//  
//

import UIKit

class ViewController: UIViewController {
    
    
    let squareView = UIImageView()
    let slider = UISlider()
    
    var squareLeadingAnchor: NSLayoutConstraint?
    var squareTrailingAnchor: NSLayoutConstraint?
    var squareTrailingMargin = CGFloat()
    
    var viewAnimator = UIViewPropertyAnimator()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = .init(top: 0, left: 30, bottom: 0, right: 30)
        
        ///отступ высчитывается по формуле: (ширина квадрата * коэффициент увеличения – ширина квадрата) / 2
        squareTrailingMargin = ((Double(150) * 1.5 - Double(150)) / 2)
        
        createSquareView()
        createSlider()
        createViewAnimation()
        
        slider.addTarget(self, action: #selector(sliderTouched(sender:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
    }
    
    
    
    func createSquareView() {
        squareView.image = UIImage(named: "cat before")
        squareView.contentMode = .scaleAspectFit
        squareView.layer.cornerRadius = 7
        squareView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(squareView)
        
        let constraints = [
            squareView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            squareView.widthAnchor.constraint(equalToConstant: 150),
            squareView.heightAnchor.constraint(equalTo: squareView.widthAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        squareTrailingAnchor = squareView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -squareTrailingMargin)
        squareLeadingAnchor = squareView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        
        isTrailingAnchorOn(false)
    }
    
    
    
    func createSlider() {
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)
        
        let constraints = [
            slider.topAnchor.constraint(equalTo: squareView.bottomAnchor, constant: 100),
            slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    
    func createViewAnimation() {
        viewAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: { [self] in
            squareView.transform = .init(rotationAngle: CGFloat.pi/2).scaledBy(x: 1.5, y: 1.5)
            isTrailingAnchorOn(true)
            view.layoutIfNeeded()
        })
    }
    
    
    
    func isTrailingAnchorOn(_ activated: Bool) {
        squareLeadingAnchor?.isActive = !activated
        squareTrailingAnchor?.isActive = activated
    }
    
    
    
    @objc func sliderTouched(sender: UISlider) {
        UIView.animate(withDuration: 0.4) { sender.setValue(sender.maximumValue, animated: true)}
        viewAnimator.continueAnimation(withTimingParameters: .none, durationFactor: 0)
        if sender.value >= 1 { squareView.image = UIImage(named: "cat after") }
    }
    
    
    @objc func valueChanged(sender: UISlider) {
        let sliderValue = CGFloat(sender.value)
        if sender.value < 1 { squareView.image = UIImage(named: "cat before") }
        
        viewAnimator.fractionComplete = sliderValue
        viewAnimator.pausesOnCompletion = true
    }
}
