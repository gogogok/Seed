//
//  SplashViewController.swift
//  rooh_test
//
//  Created by Дарья Жданок on 6.04.26.
//

import UIKit

class SplashViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        
        static let logoName: String = "seed"
        static let logoCenterY: CGFloat = -40
        static let logoSize: CGFloat = 200
        
        static let userNameKey = "userName"
        
        static let dropSize: CGFloat = 12
        static let dropsCount = 5
        static let orbitRadius: CGFloat = 100
        static let backgroundColor: UIColor = UIColor(named: "NeumorphicBackground") ?? .white
        static let accentColor: UIColor = UIColor(named: "NeumorphicAccentMint") ?? .systemTeal
        static let dropsColor: UIColor = UIColor(named: "DropsColor") ?? .systemTeal
    }
    
    // MARK: - Fields
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.logoName)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        return imageView
    }()
    
    private var drops: [UIView] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startComplexAnimation()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        view.addSubview(logoImageView)
        
        logoImageView.pinCenterX(to: view)
        logoImageView.pinCenterY(to: view, Constants.logoCenterY)
        logoImageView.setWidth(Constants.logoSize)
        logoImageView.setHeight(Constants.logoSize)
        
        createDrops()
    }
    
    // MARK: - Animation
    private func createDrops() {
        for _ in 0..<Constants.dropsCount {
            let drop = UIView()
            drop.backgroundColor = Constants.dropsColor
            drop.layer.cornerRadius = Constants.dropSize / 2
            drop.alpha = 0
            drop.frame = CGRect(x: 0, y: 0, width: Constants.dropSize, height: Constants.dropSize)
            
            drop.layer.shadowColor = Constants.accentColor.cgColor
            drop.layer.shadowRadius = 4
            drop.layer.shadowOpacity = 0.5
            drop.layer.shadowOffset = .zero
            
            view.addSubview(drop)
            drops.append(drop)
        }
    }
    
    // MARK: - Animation Logic
    private func startComplexAnimation() {
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut) {
            self.logoImageView.alpha = 1.0
            self.logoImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.logoImageView.transform = .identity
            }
            self.animateDropsOrbit()
        }
    }
    
    private func animateDropsOrbit() {
        let center = CGPoint(x: view.center.x, y: view.center.y + Constants.logoCenterY)
        
        for (index, drop) in drops.enumerated() {
            drop.alpha = 1
            
            let path = UIBezierPath(arcCenter: center,
                                    radius: Constants.orbitRadius,
                                    startAngle: CGFloat(index) * (2 * .pi / CGFloat(Constants.dropsCount)),
                                    endAngle: CGFloat(index) * (2 * .pi / CGFloat(Constants.dropsCount)) + 2 * .pi,
                                    clockwise: true)
            
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.path = path.cgPath
            animation.duration = 1.5
            animation.repeatCount = 1
            animation.calculationMode = .paced
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            drop.layer.add(animation, forKey: "orbit")
            
            let angle = CGFloat(index) * (2 * .pi / CGFloat(Constants.dropsCount))
            drop.center = CGPoint(x: center.x + Constants.orbitRadius * cos(angle),
                                  y: center.y + Constants.orbitRadius * sin(angle))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) {
                for drop in self.drops {
                    drop.center = center
                    drop.transform = CGAffineTransform(scaleX: 0.5, y: 0.5) //
                }
            } completion: { _ in
                
                self.animateDropsFalling()
            }
        }
    }
    
    private func animateDropsFalling() {
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn) {
            for drop in self.drops {
                drop.center.y += self.view.frame.height
            }
            
            self.logoImageView.transform = CGAffineTransform(translationX: 0, y: 20).scaledBy(x: 0.9, y: 0.9)
            self.logoImageView.alpha = 0
            
        } completion: { _ in
            self.openNextScreen()
        }
    }
    
    // MARK: - Navigation
    private func openNextScreen() {
        let userName = UserDefaults.standard.string(forKey: Constants.userNameKey)
        
        let nextVC: UIViewController
        
        if let userName, !userName.isEmpty {
            nextVC = MainTabBarAssembly.build()
        } else {
            let onboardingVC = OnboardingAssembly.build() as! OnboardingViewController
            
            onboardingVC.onNameSaved = { [weak onboardingVC] name in
                UserDefaults.standard.set(name, forKey: Constants.userNameKey)

                let mainVC = MainTabBarAssembly.build()

                if let sceneDelegate = onboardingVC?.view.window?.windowScene?.delegate as? SceneDelegate,
                   let window = sceneDelegate.window {
                    window.rootViewController = mainVC
                    UIView.transition(
                        with: window,
                        duration: 0.35,
                        options: .transitionCrossDissolve,
                        animations: nil
                    )
                }
            }
            
            nextVC = onboardingVC
        }
        
        switchRoot(to: nextVC)
    }
    
    private func openDashboard() {
        let dashboardVC = DashboardAssembly.build()
        navigationController?.setViewControllers([dashboardVC], animated: true)
    }

    private func switchRoot(to viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = viewController
            UIView.transition(
                with: window,
                duration: 0.35,
                options: .transitionCrossDissolve,
                animations: nil
            )
        } else {
            present(viewController, animated: true)
        }
    }
}
