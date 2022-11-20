import Content
import Core

extension ValidatorRequirement {
    var emailErrorMessage: String {
        switch self {
        case .nonEmpty: return Content.copy("error.email.empty")
        case .regex: return Content.copy("error.email.invalid")
        default: return ""
        }
    }

    var nameErrorMessage: String {
        switch self {
        case .maximumLength: return Content.copy("error.name.long")
        default: return ""
        }
    }

    var usernameErrorMessage: String {
        switch self {
        case .nonEmpty: return Content.copy("error.username.empty")
        case .minimumLength: return Content.copy("error.username.short")
        case .maximumLength: return Content.copy("error.username.long")
        case .allowedCharacters: return Content.copy("error.username.invalid")
        case .allowedStartCharacters: return Content.copy("error.username.start")
        case .allowedEndCharacters: return Content.copy("error.username.end")
        default: return ""
        }
    }

    var bioErrorMessage: String {
        switch self {
        case .maximumLength: return Content.copy("error.bio.long")
        default: return ""
        }
    }

    var passwordErrorMessage: String {
        switch self {
        case .nonEmpty: return Content.copy("error.password.empty")
        case .minimumLength: return Content.copy("error.password.short")
        case .maximumLength: return Content.copy("error.password.long")
        case .requiredCharacterSets: return Content.copy("error.password.invalid")
        default: return ""
        }
    }

    var passwordConfirmationErrorMessage: String {
        switch self {
        case .same: return Content.copy("error.confirm_password.different")
        default: return ""
        }
    }

    var playlistNameErrorMessage: String {
        switch self {
        case .minimumLength: return Content.copy("error.playlist.name.short")
        case .maximumLength: return Content.copy("error.playlist.name.long")
        default: return ""
        }
    }
}
