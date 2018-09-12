//
//  EditableTextInsetsTextField.swift
//  EditableTextInsetsTextField
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGBase.CGFloat
import struct   CoreGraphics.CGGeometry.CGRect
import struct   UIKit.UIGeometry.UIEdgeInsets
import class    UIKit.UIPasteboard.UIPasteboard
import class    UIKit.UITextInput.UITextPosition

/*!
 Describes position of clear button.
 
 - Left:  Clear button is on the left.
 - Right: Clear button is on the right.
 */
public enum TextFieldClearButtonPosition {

    case left
    case right
}

/// Editable text insets text field.
public class EditableTextInsetsTextField: TextField {

    // MARK: - Public -
    // MARK: Properties

    public var clearButtonPosition: TextFieldClearButtonPosition = .right {

        didSet {

            self.layout()
        }
    }

    /// Text insets.
    public var textInsets: UIEdgeInsets = UIEdgeInsets.zero {

        didSet {

            self.layout()
        }
    }

    /// Custom caret top and bottom inset.
    public var customCaretInset: CGFloat? {

        didSet {

            self.layout()
        }
    }

    // MARK: Methods

    public override func caretRect(for position: UITextPosition) -> CGRect {

        if let caretInset = self.customCaretInset {

            var caretRect = super.caretRect(for: position)
            caretRect.origin.y = caretInset
            caretRect.size.height = self.bounds.height - 2.0 * caretInset

            return caretRect
        } else {

            return super.caretRect(for: position)
        }
    }

    public override func textRect(forBounds aBounds: CGRect) -> CGRect {

        var textRect = aBounds
        textRect.size.width = aBounds.width - self.textInsets.left - self.textInsets.right
        textRect.origin.x = self.textInsets.left
        textRect.size.height = aBounds.height - self.textInsets.top - self.textInsets.bottom
        textRect.origin.y = self.textInsets.top

        return textRect
    }

    public override func editingRect(forBounds aBounds: CGRect) -> CGRect {

        var textRect = self.textRect(forBounds: aBounds)
        if self.clearButtonMode == .never || ( self.clearButtonMode == .whileEditing && self.text?.length == 0 ) {

            return textRect
        }

        let originalClearButtonRect = super.clearButtonRect(forBounds: aBounds)
        let clearButtonRect = self.clearButtonRect(forBounds: aBounds)

        let originalButtonIsOnTheLeft = originalClearButtonRect.midX < 0.5 * aBounds.width
        let buttonIsOnTheLeft = self.clearButtonPosition == .left

        var requiredDistanceBetweenTextAndButton: CGFloat = 0.0
        if originalButtonIsOnTheLeft {

            requiredDistanceBetweenTextAndButton = originalClearButtonRect.minX - textRect.minX
        } else {

            requiredDistanceBetweenTextAndButton = textRect.maxX - originalClearButtonRect.maxX
        }

        if buttonIsOnTheLeft {

            let previousOrigin = textRect.minX
            let origin = clearButtonRect.maxX + requiredDistanceBetweenTextAndButton

            textRect.origin.x = origin
            textRect.size.width -= origin - previousOrigin
        } else {

            textRect.size.width = clearButtonRect.minX - requiredDistanceBetweenTextAndButton - textRect.minX
        }

        return textRect
    }

    public override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {

        var defaultClearButtonRect = super.clearButtonRect(forBounds: bounds)
        if self.clearButtonPosition == .left {

            defaultClearButtonRect.origin.x = textInsets.left

        } else {

            let inset = self.textInsets.right
            let positionDecrease = defaultClearButtonRect.maxX - bounds.width + inset
            defaultClearButtonRect.origin.x -= positionDecrease
        }

        return defaultClearButtonRect
    }

    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

        if action == #selector(copy(_:)) || action == #selector(cut(_:)) {

            if let selectedRange = self.selectedTextRange {

                return (self.text(in: selectedRange)?.length ?? 0) > 0

            } else {

                return false
            }

        } else if action == #selector(paste(_:)) {

            return ( UIPasteboard.general.string?.length ?? 0 ) > 0

        } else if action == #selector(select(_:)) || action == #selector(selectAll(_:)) {

            return ( self.text?.length ?? 0 ) > 0

        } else {

            return false
        }
    }
}
