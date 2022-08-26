//
//  Toast.swift
//  ToastMessage-Test
//
//  Created by Leoan Ranjit on 7/16/22.
//

import Foundation
import UIKit
import AudioToolbox

public class Toast {
    
    public static var animates: Bool = true
    
    //MARK: - Initialization
    fileprivate static var toastView : UIView = {
        
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let bundle = Bundle(for: Toast.self)
        
        view.backgroundColor = UIColor(named: "background", in: bundle, compatibleWith: nil)!
        
        view.layer.cornerRadius = view.frame.height / 2
        
        view.layer.shadowColor = UIColor.black.cgColor
        
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        view.layer.shadowRadius = 10
        
        view.layer.shadowOpacity = 0.15
        
        return view
        
    }()
    
    fileprivate static var imgStatus : UIImageView = {
        
        let img = UIImageView()
        
        img.translatesAutoresizingMaskIntoConstraints = false
        
        img.contentMode = .scaleAspectFit
        
        return img
        
    }()
    
    fileprivate static var lblStatus : UILabel = {
        
        let lbl = UILabel()
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        lbl.textColor = UIColor.darkText
                
        lbl.numberOfLines = 2
        
        return lbl
        
    }()
    
    //MARK: - Image and Label Stack View Created
    fileprivate static var imageAndLabelStackView: UIStackView = {
        
        var stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis         = .horizontal
        
        stackView.alignment = .center
        
        stackView.distribution = .fill
        
        stackView.spacing      = 5
        
        stackView.addArrangedSubview(Toast.imgStatus)
        
        stackView.addArrangedSubview(Toast.lblStatus)
        
        return stackView
        
    }()
        
    //MARK: - Constants and Variables
    
    fileprivate static weak var toastRemoveTimer: Timer?
    
    public enum State {
        
        case success
        
        case failed
        
        case warning
        
        func getImages() -> UIImage {
            
            let bundle = Bundle(for: Toast.self)

            switch self {
                
            case .success:
                return UIImage(named: "checkmark", in: bundle, compatibleWith: nil)!
                
            case .failed:
                
                return UIImage(named: "cross", in: bundle, compatibleWith: nil)!
                
            case .warning:
                
                return UIImage(named: "exclamation", in: bundle, compatibleWith: nil)!
                
            }
            
        }
        
        func getColors() -> UIColor {
            
            switch self {
                
            case .success:
                
                return UIColor.systemGreen
                
            case .failed:
                
                return UIColor.systemRed
                
            case .warning:
                
                return UIColor.systemYellow
                
            }
            
        }
        
    }
    
    //MARK: - Additional Functions
    
    fileprivate static func startClearTimer() {
        
        Toast.toastRemoveTimer = Timer.scheduledTimer(
            
        timeInterval: 2.5,
        
        target: self,
        
        selector: #selector(Toast.removeToast),
        
        userInfo: nil,
        
        repeats: false)
        
    }

    
    public static func showToast(state: State, message: String){
        
        Toast.toastRemoveTimer?.invalidate()
        
        Toast.startClearTimer()
        
        Toast.lblStatus.text = message
                
        Toast.imgStatus.image = state.getImages()
        
        Toast.imgStatus.tintColor  = state.getColors()
        
        addConstraints()
        
        AudioServicesPlaySystemSound(1520)
        
    }
    
    @objc fileprivate static func removeToast(){
        
        let window = UIApplication.shared.keyWindow!

        if animates{
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: []) {
                
                self.toastView.transform = CGAffineTransform(translationX: 0, y: 3)
                
                self.lblStatus.alpha = 0
                
                self.lblStatus.isHidden = true
                
            } completion: { _ in
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
                                
                    self.toastView.transform = CGAffineTransform(translationX: 0, y: -(16 + window.safeAreaInsets.top + (UIApplication.shared.statusBarFrame.height ) + self.toastView.frame.height))
                    
                }) { completed in
                    
                    self.toastView.removeFromSuperview()
                    
                }
                
            }
            
        }else{
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
                            
                self.toastView.transform = CGAffineTransform(translationX: 0, y: -(16 + window.safeAreaInsets.top + (UIApplication.shared.statusBarFrame.height ) + self.toastView.frame.height))
                
            }) { completed in
                
                self.toastView.removeFromSuperview()
                
            }
            
        }
        
    }
        
    fileprivate static func addConstraints(){
        
        let window = UIApplication.shared.keyWindow!
        
        window.addSubview(self.toastView)
        
        self.toastView.transform = CGAffineTransform(translationX: 0, y: -(16 + window.safeAreaInsets.top + (UIApplication.shared.statusBarFrame.height )))
        
        if animates{
            
            self.lblStatus.alpha = 0
            
            self.lblStatus.isHidden = true
            
        }else{
            
            self.lblStatus.alpha = 1
            
            self.lblStatus.isHidden = false
            
        }
        
        self.toastView.addSubview(self.imageAndLabelStackView)
        
        // Toast View Constraints
        NSLayoutConstraint.activate([
                    
            self.toastView.widthAnchor.constraint(lessThanOrEqualTo: window.widthAnchor, multiplier: 0.9),
            
            self.toastView.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            self.toastView.centerXAnchor.constraint(equalTo: window.centerXAnchor)
            
        ])
                
        // Toast View's Image Constraints
        NSLayoutConstraint.activate([
            
            self.imgStatus.widthAnchor.constraint(equalTo: window.widthAnchor, multiplier: 0.05),
            
            self.imgStatus.heightAnchor.constraint(equalTo: self.imgStatus.widthAnchor),
            
            self.imageAndLabelStackView.leadingAnchor.constraint(equalTo: self.toastView.leadingAnchor, constant: 10),
            
            self.imageAndLabelStackView.trailingAnchor.constraint(equalTo: self.toastView.trailingAnchor, constant: -10),
                        
            self.imageAndLabelStackView.topAnchor.constraint(equalTo: self.toastView.topAnchor, constant: 10),
            
            self.toastView.bottomAnchor.constraint(equalTo: self.imageAndLabelStackView.bottomAnchor, constant: 10)
            
        ])
        
        DispatchQueue.main.async {
            
            self.toastView.layer.cornerRadius = self.toastView.frame.height / 2
            
        }
        
       
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: []) {
            
            self.toastView.transform = .identity
            
        } completion: { completed in
            
            if animates{
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: []) {
                    
                    self.lblStatus.alpha = 1
                    
                    self.lblStatus.isHidden = false
                    
                } completion: { _ in }
                
            }
            
        }

    }

}

