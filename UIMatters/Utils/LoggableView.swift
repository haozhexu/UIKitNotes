//
//  Loggable.swift
//  UIMatters
//
//  Created by Haozhe XU on 3/5/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import Foundation
import UIKit

class LoggableView: UIView {

    override class var layerClass: AnyClass {
        Logger.shared.logMethodStart()
        let cls: AnyClass = UIView.layerClass
        Logger.shared.logMethodEnd()
        return cls
    }
    
    override init(frame: CGRect) {
        Logger.shared.logMethodStart()
        super.init(frame: frame)
        Logger.shared.logMethodEnd()
    }
    
    required init?(coder aDecoder: NSCoder) {
        Logger.shared.logMethodStart()
        super.init(coder: aDecoder)
        Logger.shared.logMethodEnd()
    }
    
    override func awakeFromNib() {
        Logger.shared.logMethodStart()
        super.awakeFromNib()
        Logger.shared.logMethodEnd()
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        Logger.shared.logMethodStart()
        super.willMove(toSuperview: newSuperview)
        Logger.shared.logMethodEnd()
    }
    
    override func didMoveToSuperview() {
        Logger.shared.logMethodStart()
        super.didMoveToSuperview()
        Logger.shared.logMethodEnd()
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        Logger.shared.logMethodStart()
        super.willMove(toWindow: newWindow)
        Logger.shared.logMethodEnd()
    }
    
    override func didMoveToWindow() {
        Logger.shared.logMethodStart()
        super.didMoveToWindow()
        Logger.shared.logMethodEnd()
    }
    
    override func removeFromSuperview() {
        Logger.shared.logMethodStart()
        super.removeFromSuperview()
        Logger.shared.logMethodEnd()
    }
    
    override func addSubview(_ view: UIView) {
        Logger.shared.logMethodStart()
        super.addSubview(view)
        Logger.shared.logMethodEnd()
    }
    
    override func insertSubview(_ view: UIView, at index: Int) {
        Logger.shared.logMethodStart()
        super.insertSubview(view, at: index)
        Logger.shared.logMethodEnd()
    }
    
    override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        Logger.shared.logMethodStart()
        super.insertSubview(view, aboveSubview: siblingSubview)
        Logger.shared.logMethodEnd()
    }
    
    override func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        Logger.shared.logMethodStart()
        super.insertSubview(view, belowSubview: siblingSubview)
        Logger.shared.logMethodEnd()
    }
    
    override func bringSubview(toFront view: UIView) {
        Logger.shared.logMethodStart()
        super.bringSubview(toFront: view)
        Logger.shared.logMethodEnd()
    }
    
    override func sendSubview(toBack view: UIView) {
        Logger.shared.logMethodStart()
        super.sendSubview(toBack: view)
        Logger.shared.logMethodEnd()
    }
    
    override func didAddSubview(_ subview: UIView) {
        Logger.shared.logMethodStart()
        super.didAddSubview(subview)
        Logger.shared.logMethodEnd()
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        Logger.shared.logMethodStart()
        super.willRemoveSubview(subview)
        Logger.shared.logMethodEnd()
    }
    
    override func isDescendant(of view: UIView) -> Bool {
        Logger.shared.logMethodStart()
        let isDescendant = super.isDescendant(of: view)
        Logger.shared.logMethodEnd()
        return isDescendant
    }
    
    override func viewWithTag(_ tag: Int) -> UIView? {
        Logger.shared.logMethodStart()
        let view = super.viewWithTag(tag)
        Logger.shared.logMethodEnd()
        return view
    }
    
    override func exchangeSubview(at index1: Int, withSubviewAt index2: Int) {
        Logger.shared.logMethodStart()
        super.exchangeSubview(at: index1, withSubviewAt: index2)
        Logger.shared.logMethodEnd()
    }
    
    override func layoutMarginsDidChange() {
        Logger.shared.logMethodStart()
        super.layoutMarginsDidChange()
        Logger.shared.logMethodEnd()
    }
    
    override func safeAreaInsetsDidChange() {
        Logger.shared.logMethodStart()
        super.safeAreaInsetsDidChange()
        Logger.shared.logMethodEnd()
    }
    
    override func updateConstraintsIfNeeded() {
        Logger.shared.logMethodStart()
        super.updateConstraintsIfNeeded()
        Logger.shared.logMethodEnd()
    }
    
    override func updateConstraints() {
        Logger.shared.logMethodStart()
        super.updateConstraints()
        Logger.shared.logMethodEnd()
    }
    
    override func needsUpdateConstraints() -> Bool {
        Logger.shared.logMethodStart()
        let needs = super.needsUpdateConstraints()
        Logger.shared.logMethodEnd()
        return needs
    }
    
    override func setNeedsUpdateConstraints() {
        Logger.shared.logMethodStart()
        super.setNeedsUpdateConstraints()
        Logger.shared.logMethodEnd()
    }
    
    override var translatesAutoresizingMaskIntoConstraints: Bool {
        set {
            Logger.shared.logMethodStart()
            super.translatesAutoresizingMaskIntoConstraints = newValue
            Logger.shared.logMethodEnd()
        }
        get {
            Logger.shared.logMethodStart()
            let translates = super.translatesAutoresizingMaskIntoConstraints
            Logger.shared.logMethodEnd()
            return translates
        }
    }
    
    override func alignmentRect(forFrame frame: CGRect) -> CGRect {
        Logger.shared.logMethodStart()
        let rect = super.alignmentRect(forFrame: frame)
        Logger.shared.logMethodEnd()
        return rect
    }
    
    override func frame(forAlignmentRect alignmentRect: CGRect) -> CGRect {
        Logger.shared.logMethodStart()
        let frame = super.frame(forAlignmentRect: alignmentRect)
        Logger.shared.logMethodEnd()
        return frame
    }
    
    override var alignmentRectInsets: UIEdgeInsets {
        get {
            Logger.shared.logMethodStart()
            let insets = super.alignmentRectInsets
            Logger.shared.logMethodEnd()
            return insets
        }
    }
    
    override var forFirstBaselineLayout: UIView {
        Logger.shared.logMethodStart()
        let view = super.forFirstBaselineLayout
        Logger.shared.logMethodEnd()
        return view
    }
    
    override var forLastBaselineLayout: UIView {
        Logger.shared.logMethodStart()
        let view = super.forLastBaselineLayout
        Logger.shared.logMethodEnd()
        return view
    }
    
    override var intrinsicContentSize: CGSize {
        Logger.shared.logMethodStart()
        let size = super.intrinsicContentSize
        Logger.shared.logMethodEnd()
        return size
    }
    
    override func invalidateIntrinsicContentSize() {
        Logger.shared.logMethodStart()
        super.invalidateIntrinsicContentSize()
        Logger.shared.logMethodEnd()
    }
    
    override func contentHuggingPriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority {
        Logger.shared.logMethodStart()
        let priority = super.contentHuggingPriority(for: axis)
        Logger.shared.logMethodEnd()
        return priority
    }
    
    override func setContentHuggingPriority(_ priority: UILayoutPriority, for axis: UILayoutConstraintAxis) {
        Logger.shared.logMethodStart()
        super.setContentHuggingPriority(priority, for: axis)
        Logger.shared.logMethodEnd()
    }
    
    override func contentCompressionResistancePriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority {
        Logger.shared.logMethodStart()
        let resistance = super.contentCompressionResistancePriority(for: axis)
        Logger.shared.logMethodEnd()
        return resistance
    }
    
    override func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: UILayoutConstraintAxis) {
        Logger.shared.logMethodStart()
        super.setContentCompressionResistancePriority(priority, for: axis)
        Logger.shared.logMethodEnd()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        Logger.shared.logMethodStart()
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        Logger.shared.logMethodEnd()
        return size
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        Logger.shared.logMethodStart()
        let size = super.systemLayoutSizeFitting(targetSize)
        Logger.shared.logMethodEnd()
        return size
    }
    
    override func constraintsAffectingLayout(for axis: UILayoutConstraintAxis) -> [NSLayoutConstraint] {
        Logger.shared.logMethodStart()
        let constraints = super.constraintsAffectingLayout(for: axis)
        Logger.shared.logMethodEnd()
        return constraints
    }
    
    override var hasAmbiguousLayout: Bool {
        Logger.shared.logMethodStart()
        let ambiguous = super.hasAmbiguousLayout
        Logger.shared.logMethodEnd()
        return ambiguous
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        Logger.shared.logMethodStart()
        super.encodeRestorableState(with: coder)
        Logger.shared.logMethodEnd()
    }
    
    override func snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView? {
        Logger.shared.logMethodStart()
        let view = super.snapshotView(afterScreenUpdates: afterUpdates)
        Logger.shared.logMethodEnd()
        return view
    }
    
    override func resizableSnapshotView(from rect: CGRect, afterScreenUpdates afterUpdates: Bool, withCapInsets capInsets: UIEdgeInsets) -> UIView? {
        Logger.shared.logMethodStart()
        let view = super.resizableSnapshotView(from: rect, afterScreenUpdates: afterUpdates, withCapInsets: capInsets)
        Logger.shared.logMethodEnd()
        return view
    }
    
    override func drawHierarchy(in rect: CGRect, afterScreenUpdates afterUpdates: Bool) -> Bool {
        Logger.shared.logMethodStart()
        let draw = super.drawHierarchy(in: rect, afterScreenUpdates: afterUpdates)
        Logger.shared.logMethodEnd()
        return draw
    }
    
    override func setNeedsLayout() {
        Logger.shared.logMethodStart()
        super.setNeedsLayout()
        Logger.shared.logMethodEnd()
    }
    
    override func layoutIfNeeded() {
        Logger.shared.logMethodStart()
        super.layoutIfNeeded()
        Logger.shared.logMethodEnd()
    }
    
    override func layoutSubviews() {
        Logger.shared.logMethodStart()
        super.layoutSubviews()
        Logger.shared.logMethodEnd()
    }
    
    override func setNeedsDisplay() {
        Logger.shared.logMethodStart()
        super.setNeedsDisplay()
        Logger.shared.logMethodEnd()
    }
    
    override func setNeedsDisplay(_ rect: CGRect) {
        Logger.shared.logMethodStart()
        super.setNeedsDisplay(rect)
        Logger.shared.logMethodEnd()
    }
    
    override func hitTest(_ point: CGPoint,
                 with event: UIEvent?) -> UIView? {
        Logger.shared.logMethodStart()
        let view = super.hitTest(point, with: event)
        Logger.shared.logMethodEnd()
        return view
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        Logger.shared.logMethodStart()
        let isInside = super.point(inside: point, with: event)
        Logger.shared.logMethodEnd()
        return isInside
    }
    
    override func convert(_ point: CGPoint, to view: UIView?) -> CGPoint {
        Logger.shared.logMethodStart()
        let convertedPoint = super.convert(point, to: view)
        Logger.shared.logMethodEnd()
        return convertedPoint
    }
    
    override func convert(_ point: CGPoint, from view: UIView?) -> CGPoint {
        Logger.shared.logMethodStart()
        let convertedPoint = super.convert(point, from: view)
        Logger.shared.logMethodEnd()
        return convertedPoint
    }
    
    override func convert(_ rect: CGRect, to view: UIView?) -> CGRect {
        Logger.shared.logMethodStart()
        let convertedRect = super.convert(rect, to: view)
        Logger.shared.logMethodEnd()
        return convertedRect
    }
    
    override func convert(_ rect: CGRect, from view: UIView?) -> CGRect {
        Logger.shared.logMethodStart()
        let convertedRect = super.convert(rect, from: view)
        Logger.shared.logMethodEnd()
        return convertedRect
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        Logger.shared.logMethodStart()
        let size = super.sizeThatFits(size)
        Logger.shared.logMethodEnd()
        return size
    }
    
    override func sizeToFit() {
        Logger.shared.logMethodStart()
        super.sizeToFit()
        Logger.shared.logMethodEnd()
    }
    
    override func tintColorDidChange() {
        Logger.shared.logMethodStart()
        super.tintColorDidChange()
        Logger.shared.logMethodEnd()
    }
    
    override func addConstraint(_ constraint: NSLayoutConstraint) {
        Logger.shared.logMethodStart()
        super.addConstraint(constraint)
        Logger.shared.logMethodEnd()
    }
    
    override func addConstraints(_ constraints: [NSLayoutConstraint]) {
        Logger.shared.logMethodStart()
        super.addConstraints(constraints)
        Logger.shared.logMethodEnd()
    }
    
    override func removeConstraint(_ constraint: NSLayoutConstraint) {
        Logger.shared.logMethodStart()
        super.removeConstraint(constraint)
        Logger.shared.logMethodEnd()
    }
    
    override func removeConstraints(_ constraints: [NSLayoutConstraint]) {
        Logger.shared.logMethodStart()
        super.removeConstraints(constraints)
        Logger.shared.logMethodEnd()
    }
    
    override func addMotionEffect(_ effect: UIMotionEffect) {
        Logger.shared.logMethodStart()
        super.addMotionEffect(effect)
        Logger.shared.logMethodEnd()
    }
    
    override func removeMotionEffect(_ effect: UIMotionEffect) {
        Logger.shared.logMethodStart()
        super.removeMotionEffect(effect)
        Logger.shared.logMethodEnd()
    }
    
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        Logger.shared.logMethodStart()
        super.addGestureRecognizer(gestureRecognizer)
        Logger.shared.logMethodEnd()
    }
    
    override func removeGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        Logger.shared.logMethodStart()
        super.removeGestureRecognizer(gestureRecognizer)
        Logger.shared.logMethodEnd()
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        Logger.shared.logMethodStart()
        let shouldBegin = super.gestureRecognizerShouldBegin(gestureRecognizer)
        Logger.shared.logMethodEnd()
        return shouldBegin
    }
}
