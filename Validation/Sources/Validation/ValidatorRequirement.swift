import Foundation

public enum ValidatorRequirement: Hashable {
    case nonEmpty
    case same(String)
    case minimumLength(Int)
    case maximumLength(Int)
    case allowedCharacters(CharacterSet)
    case allowedStartCharacters(CharacterSet)
    case allowedEndCharacters(CharacterSet)
    case requiredCharacterSets([CharacterSet])
    case regex(ValidatorRegex)

    // swiftlint:disable:next cyclomatic_complexity
    func validate(_ input: String) -> Bool {
        switch self {
        case .nonEmpty:
            return !input.isEmpty
        case .same(let other):
            return input == other
        case .minimumLength(let length):
            return input.count >= length
        case .maximumLength(let length):
            return input.count <= length
        case .allowedCharacters(let characterSet):
            return characterSet.isSuperset(of: .init(charactersIn: input))
        case .allowedStartCharacters(let characterSet):
            if let start = input.first {
                return characterSet.isSuperset(of: .init(charactersIn: String(start)))
            } else {
                return true
            }
        case .allowedEndCharacters(let characterSet):
            if let end = input.last {
                return characterSet.isSuperset(of: .init(charactersIn: String(end)))
            } else {
                return true
            }
        case .requiredCharacterSets(let characterSets):
            return characterSets.allSatisfy { input.rangeOfCharacter(from: $0) != nil }
        case .regex(let validatorRegex):
            return input.range(of: validatorRegex.rawValue, options: .regularExpression) != nil
        }
    }
}
