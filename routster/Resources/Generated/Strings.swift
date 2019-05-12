// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// or connect with
  internal static let connectLabelText = L10n.tr("Localizable", "connectLabelText")
  /// email
  internal static let email = L10n.tr("Localizable", "email")
  /// error
  internal static let error = L10n.tr("Localizable", "error")
  /// This feature is not yet implemented in the current version.
  internal static let featureNotImplemented = L10n.tr("Localizable", "featureNotImplemented")
  /// Please make sure that you have allowed access to your location.
  internal static let locationAccess = L10n.tr("Localizable", "locationAccess")
  /// You have been logged out successfully.
  internal static let loggedOutSuccessfully = L10n.tr("Localizable", "loggedOutSuccessfully")
  /// Please log in with your komoot user account. This is needed to access your planned tours.
  internal static let loginDescriptionLabelText = L10n.tr("Localizable", "loginDescriptionLabelText")
  /// Please select the tours to which you want to calculate the current route and travel time.
  internal static let messageLabelText = L10n.tr("Localizable", "messageLabelText")
  /// note
  internal static let note = L10n.tr("Localizable", "note")
  /// password
  internal static let password = L10n.tr("Localizable", "password")
  /// An unexpected error has occurred. Please try again later.
  internal static let unexpectedError = L10n.tr("Localizable", "unexpectedError")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
