TapAdditionsKitDependencyVersion = '1.1' unless defined? TapAdditionsKitDependencyVersion

Pod::Spec.new do |editableTextInsetsTextField|
    
    editableTextInsetsTextField.platform                = :ios
    editableTextInsetsTextField.ios.deployment_target   = '8.0'
    editableTextInsetsTextField.swift_version           = '4.2'
    editableTextInsetsTextField.name                    = 'EditableTextInsetsTextField'
    editableTextInsetsTextField.summary                 = 'UITextField subclass with editable text insets.'
    editableTextInsetsTextField.requires_arc            = true
    editableTextInsetsTextField.version                 = '1.0.2'
    editableTextInsetsTextField.license                 = { :type => 'MIT', :file => 'LICENSE' }
    editableTextInsetsTextField.author                  = { 'Tap Payments' => 'hello@tap.company' }
    editableTextInsetsTextField.homepage                = 'https://github.com/Tap-Payments/EditableTextInsetsTextField-iOS'
    editableTextInsetsTextField.source                  = { :git => 'https://github.com/Tap-Payments/EditableTextInsetsTextField-iOS.git',
                                                            :tag => editableTextInsetsTextField.version.to_s }
    editableTextInsetsTextField.source_files            = 'EditableTextInsetsTextField/Source/*.swift'
    
    editableTextInsetsTextField.dependency 'TapAdditionsKit/Foundation/Locale', TapAdditionsKitDependencyVersion
    editableTextInsetsTextField.dependency 'TapAdditionsKit/UIKit/UIView',      TapAdditionsKitDependencyVersion
    
end
