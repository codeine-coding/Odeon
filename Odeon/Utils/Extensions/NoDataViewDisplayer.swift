//
//  NoDataViewDisplayer.swift
//  Odeon
//
//  Created by Allen Whearry on 7/25/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import UIKit

protocol NoDataViewDisplayer {
    var noDataView: NoDataView { get set }
    
    func showNoDataView(with state: EmptyState)
    func hideEmptyView()
}

protocol LoadingViewRequired {
    var loadingIndicator: UIActivityIndicatorView { get set }
}

extension NoDataViewDisplayer where Self: UIViewController {
    func showNoDataView(with state: EmptyState) {
        noDataView.state = state
        
        guard noDataView.superview == nil else { return }
        
        if let self = self as? LoadingViewRequired {
            self.loadingIndicator.stopAnimating()
        }
        
        view.addSubview(noDataView)
        
        NSLayoutConstraint.activate([
            noDataView.topAnchor.constraint(equalTo: view.topAnchor),
            noDataView.leftAnchor.constraint(equalTo: view.leftAnchor),
            noDataView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noDataView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func hideEmptyView() {
        noDataView.removeFromSuperview()
    }
}
