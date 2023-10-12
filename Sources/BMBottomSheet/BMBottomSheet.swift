//
//  PopupViewController.swift
//  RestFood
//
//  Created by Владислав Миронов on 06.10.2022.
//

import Foundation
import UIKit

public class BMBottomSheet: UIViewController {

    // MARK: - Public Properties
    public var insets: UIEdgeInsets = .init(top: 4, left: 4, bottom: 4, right: 4)
    public var fadeBackgroundColor = UIColor.black.withAlphaComponent(0.4)

    // MARK: - Private Properties
    private var bottomConstraint: NSLayoutConstraint?
    private var firstViewDidLayoutSubviews = true
    private let childController: UIViewController

    private var sheetView: UIView {
        childController.view
    }

    // MARK: - Lifecycle
    public init(childController: UIViewController) {
        self.childController = childController
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupRecognizer()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstViewDidLayoutSubviews {
            hideSheet()
            firstViewDidLayoutSubviews = false
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSheetAnimated()
    }

    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = fadeBackgroundColor
        view.addSubview(sheetView)
    }

    private func setupConstraints() {
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom)
        self.bottomConstraint = bottomConstraint

        let topConstraint = sheetView.topAnchor.constraint(
            greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 16
        )
        topConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            bottomConstraint,
            topConstraint
        ])
    }

    private func setupRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideSheetAnimated))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(gesture:)))
        sheetView.addGestureRecognizer(pan)
    }

    private func hideSheet() {
        bottomConstraint?.constant = sheetView.frame.height
    }

    private func showSheet() {
        bottomConstraint?.constant = -insets.bottom
    }

    private func animateSpring(_ animation: @escaping ()->Void, completion: ((Bool)->Void)? = nil) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.85, options: .curveEaseIn, animations: animation, completion: completion)
    }

    // MARK: - Handlers
    @objc private func panGestureHandler(gesture: UIPanGestureRecognizer) {
        let translationY = gesture.translation(in: self.view).y
        let velocity = gesture.velocity(in: self.view)
        switch gesture.state {
        case .changed:
            let positiveTranslation = sqrt(abs(translationY))
            let posY = translationY < 0 ? -positiveTranslation : translationY
            bottomConstraint?.constant = posY
        case .ended, .cancelled:
            if translationY > 300 || velocity.y > 150 {
                hideSheetAnimated()
            } else {
                showSheetAnimated()
            }
        default:()
        }
    }

    @objc private func showSheetAnimated() {
        showSheet()
        animateSpring { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = fadeBackgroundColor
            self.view.layoutIfNeeded()
        }
    }

   @objc private func hideSheetAnimated() {
       hideSheet()
       animateSpring { [weak self] in
           guard let self = self else { return }
           self.view.backgroundColor = fadeBackgroundColor.withAlphaComponent(0)
           self.view.layoutIfNeeded()
       } completion: { [weak self] _ in
           self?.dismiss(animated: false)
       }
    }
}

extension BMBottomSheet: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let tapGesture = gestureRecognizer as? UITapGestureRecognizer {
            let point = tapGesture.location(in: view)
            return !sheetView.frame.contains(point)
        }
        return true
    }
}
