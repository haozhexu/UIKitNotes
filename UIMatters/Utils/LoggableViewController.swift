//
//  LoggableViewController.swift
//  UIMatters
//
//  Created by Haozhe XU on 14/5/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import UIKit

class LoggableViewController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        Logger.shared.logMethodStart()
        super.init(coder: aDecoder)
        Logger.shared.logMethodEnd()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        Logger.shared.logMethodStart()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Logger.shared.logMethodEnd()
    }
    
    override func awakeFromNib() {
        Logger.shared.logMethodStart()
        super.awakeFromNib()
        Logger.shared.logMethodEnd()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Logger.shared.logMethodStart()
        super.prepare(for: segue, sender: sender)
        Logger.shared.logMethodEnd()
    }
    
    override func loadView() {
        Logger.shared.logMethodStart()
        super.loadView()
        Logger.shared.logMethodEnd()
    }
    
    override func viewDidLoad() {
        Logger.shared.logMethodStart()
        super.viewDidLoad()
        Logger.shared.logMethodEnd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Logger.shared.logMethodStart()
        super.viewWillAppear(animated)
        Logger.shared.logMethodEnd()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Logger.shared.logMethodStart()
        super.viewDidAppear(animated)
        Logger.shared.logMethodEnd()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Logger.shared.logMethodStart()
        super.viewWillDisappear(animated)
        Logger.shared.logMethodEnd()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Logger.shared.logMethodStart()
        super.viewWillDisappear(animated)
        Logger.shared.logMethodEnd()
    }
    
    override func viewWillLayoutSubviews() {
        Logger.shared.logMethodStart()
        super.viewWillLayoutSubviews()
        Logger.shared.logMethodEnd()
    }
    
    override func viewDidLayoutSubviews() {
        Logger.shared.logMethodStart()
        super.viewDidLayoutSubviews()
        Logger.shared.logMethodEnd()
    }
    
    override var isBeingPresented: Bool {
        Logger.shared.logMethodStart()
        let beingPresented = super.isBeingPresented
        Logger.shared.logMethodEnd()
        return beingPresented
    }
    
    override var isBeingDismissed: Bool {
        Logger.shared.logMethodStart()
        let beingDismissed = super.isBeingDismissed
        Logger.shared.logMethodEnd()
        return beingDismissed
    }
    
    override var isMovingToParentViewController: Bool {
        Logger.shared.logMethodStart()
        let movingToParentVC = super.isMovingToParentViewController
        Logger.shared.logMethodEnd()
        return movingToParentVC
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        Logger.shared.logMethodStart()
        super.willMove(toParentViewController: parent)
        Logger.shared.logMethodEnd()
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        Logger.shared.logMethodStart()
        super.didMove(toParentViewController: parent)
        Logger.shared.logMethodEnd()
    }

    override var shouldAutorotate: Bool {
        Logger.shared.logMethodStart()
        let rtn = super.shouldAutorotate
        Logger.shared.logMethodEnd()
        return rtn
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        Logger.shared.logMethodStart()
        let rtn = super.supportedInterfaceOrientations
        Logger.shared.logMethodEnd()
        return rtn
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        Logger.shared.logMethodStart()
        let rtn = super.preferredInterfaceOrientationForPresentation
        Logger.shared.logMethodEnd()
        return rtn
    }
    
    override var edgesForExtendedLayout: UIRectEdge {
        get {
            Logger.shared.logMethodStart()
            let rtn = super.edgesForExtendedLayout
            Logger.shared.logMethodEnd()
            return rtn
        }
        set {
            Logger.shared.logMethodStart()
            super.edgesForExtendedLayout = newValue
            Logger.shared.logMethodEnd()
        }
    }
    
    override var extendedLayoutIncludesOpaqueBars: Bool {
        get {
            Logger.shared.logMethodStart()
            let rtn = super.extendedLayoutIncludesOpaqueBars
            Logger.shared.logMethodEnd()
            return rtn
        }
        set {
            Logger.shared.logMethodStart()
            super.extendedLayoutIncludesOpaqueBars = newValue
            Logger.shared.logMethodEnd()
        }
    }
    
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        get {
            Logger.shared.logMethodStart()
            let rtn = super.shouldAutomaticallyForwardAppearanceMethods
            Logger.shared.logMethodEnd()
            return rtn
        }
    }
    
    override var preferredContentSize: CGSize {
        get {
            Logger.shared.logMethodStart()
            let rtn = super.preferredContentSize
            Logger.shared.logMethodEnd()
            return rtn
        }
        set {
            Logger.shared.logMethodStart()
            super.preferredContentSize = newValue
            Logger.shared.logMethodEnd()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            Logger.shared.logMethodStart()
            let rtn = super.preferredStatusBarStyle
            Logger.shared.logMethodEnd()
            return rtn
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            Logger.shared.logMethodStart()
            let rtn = super.prefersStatusBarHidden
            Logger.shared.logMethodEnd()
            return rtn
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get {
            Logger.shared.logMethodStart()
            let rtn = super.preferredStatusBarUpdateAnimation
            Logger.shared.logMethodEnd()
            return rtn
        }
    }
    
    override func setNeedsStatusBarAppearanceUpdate() {
        Logger.shared.logMethodStart()
        super.setNeedsStatusBarAppearanceUpdate()
        Logger.shared.logMethodEnd()
    }
    
    override func updateViewConstraints() {
        Logger.shared.logMethodStart()
        super.updateViewConstraints()
        Logger.shared.logMethodEnd()
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        Logger.shared.logMethodStart()
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        Logger.shared.logMethodEnd()
    }
    
    override func systemLayoutFittingSizeDidChange(forChildContentContainer container: UIContentContainer) {
        Logger.shared.logMethodStart()
        super.systemLayoutFittingSizeDidChange(forChildContentContainer: container)
        Logger.shared.logMethodEnd()
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        Logger.shared.logMethodStart()
        let rtn = super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        Logger.shared.logMethodEnd()
        return rtn
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        Logger.shared.logMethodStart()
        super.viewWillTransition(to: size, with: coordinator)
        Logger.shared.logMethodEnd()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        Logger.shared.logMethodStart()
        super.willTransition(to: newCollection, with: coordinator)
        Logger.shared.logMethodEnd()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        Logger.shared.logMethodStart()
        super.traitCollectionDidChange(previousTraitCollection)
        Logger.shared.logMethodEnd()
    }
    
    override var restorationIdentifier: String? {
        get {
            Logger.shared.logMethodStart()
            let rtn = super.restorationIdentifier
            Logger.shared.logMethodEnd()
            return rtn
        }
        set {
            Logger.shared.logMethodStart()
            super.restorationIdentifier = newValue
            Logger.shared.logMethodEnd()
        }
    }
    
    override var restorationClass: UIViewControllerRestoration.Type? {
        get {
            Logger.shared.logMethodStart()
            let rtn = super.restorationClass
            Logger.shared.logMethodEnd()
            return rtn
        }
        set {
            Logger.shared.logMethodStart()
            super.restorationClass = newValue
            Logger.shared.logMethodEnd()
        }
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        Logger.shared.logMethodStart()
        super.encodeRestorableState(with: coder)
        Logger.shared.logMethodEnd()
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        Logger.shared.logMethodStart()
        super.decodeRestorableState(with: coder)
        Logger.shared.logMethodEnd()
    }
    
    override func applicationFinishedRestoringState() {
        Logger.shared.logMethodStart()
        super.applicationFinishedRestoringState()
        Logger.shared.logMethodEnd()
    }
}
