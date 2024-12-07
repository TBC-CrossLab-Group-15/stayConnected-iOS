//
//  LoadingIndicator.swift
//  stayConnected-iOS
//
//  Created by Despo on 07.12.24.
//

import UIKit

final class LoadingIndicator: UIView {
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        activityIndicator.color = .primaryViolet
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)

        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func startAnimating() {
        activityIndicator.startAnimating()
        self.isHidden = false
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
        self.isHidden = true
    }
}
