
import Foundation
import UIKit

class CustomPopupView: UIView {
    
    // MARK: PROPERTIES -
    
    private var coverView: UIView?
    private var animationType: PopupAnimationType
    
    var actions: [PopupAction] = [] {
        didSet {
            configureActions()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let actionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: MAIN -
    
    init(title: String, message: String, animationType: PopupAnimationType) {
        self.animationType = animationType
        super.init(frame: .zero)
        setUpViews()
        setUpConstraints()
        titleLabel.text = title
        messageLabel.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        layer.cornerRadius = 6
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(actionStackView)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            messageLabel.bottomAnchor.constraint(equalTo: actionStackView.topAnchor, constant: -30),
            
            actionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            actionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            actionStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            actionStackView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func configureActions() {
        actionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        actions.forEach { action in
            let button = UIButton(type: .system)
            button.setTitle(action.title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            button.layer.cornerRadius = 6
            
            switch action.buttonType {
            case .destructive:
                button.backgroundColor = .red
                button.setTitleColor(.white, for: .normal)
            case .cancel:
                button.backgroundColor = .lightGray.withAlphaComponent(0.2)
                button.setTitleColor(.black, for: .normal)
            case ._default:
                button.backgroundColor = .black
                button.setTitleColor(.white, for: .normal)
            }
            
            button.addTarget(self, action: #selector(handleAction(_:)), for: .touchUpInside)
            actionStackView.addArrangedSubview(button)
        }
    }
    
    func present(on view: UIView, coverView: UIView) {
        
        self.coverView = coverView
        view.addSubview(coverView)
        view.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch animationType {
        case .slideInBottom:
            
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: view.leadingAnchor),
                trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: frame.height)
            ])
            
            view.layoutIfNeeded()
            
            // Animate the cover view
            coverView.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                coverView.alpha = 1
            })
            
            // Animate the pop-up view sliding in from the bottom
            self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                self.transform = .identity
            }, completion: nil)
            
            break
        case .scale:
            
            NSLayoutConstraint.activate([
                centerYAnchor.constraint(equalTo: view.centerYAnchor),
                leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
            ])
            
            // Animate the cover view
            coverView.alpha = 0
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    
            UIView.animate(withDuration: 0.3, animations: {
                coverView.alpha = 1
                self.alpha = 1
                self.transform = CGAffineTransform.identity
            })
            
            break
        }
        
    }
    
    private func dismiss() {
        
        guard let coverView = coverView else { return }
        
        switch animationType {
        case .slideInBottom:
            
            UIView.animate(withDuration: 0.3, animations: {
                coverView.alpha = 0
            }) { _ in
                coverView.removeFromSuperview()
            }
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
                self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
            }) { _ in
                self.removeFromSuperview()
            }
            
            break
        case .scale:
            
            UIView.animate(withDuration: 0.2, animations: {
                coverView.alpha = 0
                self.alpha = 0
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { _ in
                coverView.removeFromSuperview()
                self.removeFromSuperview()
            }
            
            break
        }
                           
    }

    // MARK: - ACTIONS
    
    @objc private func handleAction(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        let action = actions.first { $0.title == title }
        action?.handler?()
        dismiss()
    }
    
}
