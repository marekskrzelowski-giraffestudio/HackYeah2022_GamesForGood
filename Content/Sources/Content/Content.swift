import SwiftUI

public struct Content {
    public static func copy(_ key: String, arguments: [CVarArg] = []) -> String {
        let localized = String(localized: .init(stringLiteral: key), bundle: .module)
        return .init(format: localized, arguments: arguments)
    }

    public static func color(_ color: ColorAsset) -> Color {
        .init(color.rawValue, bundle: .module)
    }

    public static func image(_ image: ImageAsset) -> Image {
        .init(image.rawValue, bundle: .module)
    }
}

public extension Content {
    enum ColorAsset: String {
        case accentNormal = "accent_normal"
        case blackBlack = "black_black"
        case blackDarkGrey = "black_darkgrey"
        case blackGrey = "black_grey"
        case blackLight = "black_light"
        case blackLightGrey = "black_lightgrey"
        case blackSemidark = "black_semidark"
        case blackWhite = "black_white"
        case statusError = "status_error"
        case accentSecond = "accent_second"
        case accentLight = "accent_light"
    }
}

public extension Content {
    enum ImageAsset: String {
        case more
        case logotext
        case logoimage
        case mail
        case visibility
        case lock
        case lamp
        case profile
        case chart
        case logomain
        case bell
        case back
        case missionph
        case arrowright
        case water
    }
}
