//
//  UIViewController+bind.swift
//  DMSLAnalytics
//
//  Created by Dmytro Shulzhenko on 18.10.2020.
//

import UIKit
import DMSLAnalyticsCore
import RxSwift
import RxViewController

public extension UIViewController {
    func bindAnalytics(_ view: ViewEvent,
                       persistContext: Bool = true,
                       overrideContext: Bool = false,
                       bag: DisposeBag) {
        ViewControllerAnalyticsBinder(viewController: self,
                                      bag: bag,
                                      view: view,
                                      persistContext: persistContext,
                                      overrideContext: overrideContext)
            .disposed(by: bag)
    }
}

extension UIViewController {
    var rootParent: UIViewController {
        parent.map { $0.rootParent } ?? self
    }
    
    var isModal: Bool {
        guard presentingViewController != nil else {
            return false
        }
        
        guard #available(iOS 13, *) else {
            return modalPresentationStyle == .custom
        }
        
        switch modalPresentationStyle {
        case .fullScreen, .overFullScreen, .overCurrentContext:
            return false
        case .pageSheet, .formSheet, .currentContext, .custom, .popover, .none, .automatic:
            return true
        @unknown default:
            return true
        }
    }
}

final class ViewControllerAnalyticsBinder: Disposable {
    private var tracker = EventTracker.default

    private unowned let viewController: UIViewController
    private unowned let bag: DisposeBag
    private let view: ViewEvent
    private let persistContext: Bool
    private let overrideContext: Bool

    private var isModal = false
    private var previousContext: DMSLAnalyticsCore.Event.Context = .initial
    
    init(viewController: UIViewController,
         bag: DisposeBag,
         view: ViewEvent,
         persistContext: Bool,
         overrideContext: Bool) {
        self.viewController = viewController
        self.bag = bag
        self.view = view
        self.persistContext = persistContext
        self.overrideContext = overrideContext
        
        bind()
    }
    
    func dispose() { }
    
    private func bind() {
        viewController.rx.viewDidAppear
            .bind { [unowned self] _ in
                previousContext = tracker.currentContext
                isModal = viewController.rootParent.isModal
                tracker.trackView(view,
                                  persistContext: persistContext,
                                  overrideContext: overrideContext)
            }
            .disposed(by: bag)
        
        viewController.rx.viewDidDisappear
            .filter { [unowned self] _ in isModal }
            .bind { [unowned self] _ in
                tracker.currentContext = previousContext
            }
            .disposed(by: bag)
    }
}
