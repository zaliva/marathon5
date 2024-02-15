import UIKit

let bgColor = UIColor(red: 255/242, green: 255/241, blue: 255/247, alpha: 1)
let width: CGFloat = 300
let defaultHeght: CGFloat = 280

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    let heightViewController = HeightViewController()
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBAction func presentAction(_ sender: Any) {
        
        heightViewController.heightChanged = { [weak self] height in
            self?.updateHeight(height)
        }
        
        addChild(heightViewController)
        view.addSubview(heightViewController.view)
        heightViewController.didMove(toParent: self)
        heightViewController.view.translatesAutoresizingMaskIntoConstraints = false
        heightViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        heightViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        heightViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        heightViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        heightConstraint.constant = defaultHeght
    }
    
    private func updateHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.heightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
    }
}

class HeightViewController: UIViewController {
    
    var heightChanged: ((CGFloat) -> Void)?
    var segmentedControl: UISegmentedControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupShadow()
        setupSegmented()
        setupCloseBtn()
        setupTriangle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        segmentedControl?.selectedSegmentIndex = 0
    }
    
    private func setupShadow() {
        view.backgroundColor = bgColor

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        view.layer.shadowRadius = 8
        view.layer.cornerRadius = 10
    }
    
    private func setupSegmented() {
        let segmentedControl = UISegmentedControl(items: ["280pt", "150pt"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.segmentedControl = segmentedControl
    }
    
    private func setupCloseBtn() {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .gray
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    private func setupTriangle() {
        let triangleLayer = CAShapeLayer()
        let trianglePath = UIBezierPath()
        let size: CGFloat = 20
        trianglePath.move(to: CGPoint(x: size/2, y: 0))
        trianglePath.addLine(to: CGPoint(x: 0, y: size))
        trianglePath.addLine(to: CGPoint(x: size, y: size))
        trianglePath.addLine(to: CGPoint(x: size/2, y: 0))
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.fillColor = bgColor.cgColor
        triangleLayer.position = CGPoint(x: (width - size)/2, y: -size)
        view.layer.addSublayer(triangleLayer)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let newHeight: CGFloat = sender.selectedSegmentIndex == 0 ? defaultHeght : 150
        heightChanged?(newHeight)
    }
    
    @objc func closeButtonTapped() {
        removeFromParent()
        view.removeFromSuperview()
    }
}
