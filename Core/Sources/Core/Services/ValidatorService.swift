import Validation

public typealias ValidatorRequirement = Validation.ValidatorRequirement

public protocol ValidatorService {
    func validate(email: String) -> ValidatorRequirement?
    func validate(name: String) -> ValidatorRequirement?
    func validate(username: String) -> ValidatorRequirement?
    func validate(bio: String) -> ValidatorRequirement?
    func validate(password: String) -> ValidatorRequirement?
    func validate(passwordConfirmation: String, password: String) -> ValidatorRequirement?
    func validate(playlistName: String) -> ValidatorRequirement?
}

public class DefaultValidatorService: ValidatorService {
    private let validator: Validator

    public init(validator: Validator) {
        self.validator = validator
    }

    public func validate(email: String) -> ValidatorRequirement? {
        let result = validator.validate(
            email,
            requirements: [
                .nonEmpty,
                .regex(.email)
            ]
        )
        switch result {
        case .valid: return nil
        case .invalid(let failed): return failed.first
        }
    }

    public func validate(name: String) -> ValidatorRequirement? {
        let result = validator.validate(
            name,
            requirements: [
                .maximumLength(30)
            ]
        )
        switch result {
        case .valid: return nil
        case .invalid(let failed): return failed.first
        }
    }

    public func validate(username: String) -> ValidatorRequirement? {
        let result = validator.validate(
            username,
            requirements: [
                .nonEmpty,
                .minimumLength(4),
                .maximumLength(25),
                .allowedCharacters(.letters.union(.decimalDigits).union(.init([".", "_"]))),
                .allowedStartCharacters(.letters.union(.decimalDigits)),
                .allowedEndCharacters(.letters.union(.decimalDigits))
            ]
        )
        switch result {
        case .valid: return nil
        case .invalid(let failed): return failed.first
        }
    }

    public func validate(bio: String) -> ValidatorRequirement? {
        let result = validator.validate(
            bio,
            requirements: [
                .maximumLength(120)
            ]
        )
        switch result {
        case .valid: return nil
        case .invalid(let failed): return failed.first
        }
    }

    public func validate(password: String) -> ValidatorRequirement? {
        let result = validator.validate(
            password,
            requirements: [
                .nonEmpty,
                .minimumLength(8),
                .maximumLength(25),
                .requiredCharacterSets([.letters, .decimalDigits])
            ]
        )
        switch result {
        case .valid: return nil
        case .invalid(let failed): return failed.first
        }
    }

    public func validate(passwordConfirmation: String, password: String) -> ValidatorRequirement? {
        let result = validator.validate(
            passwordConfirmation,
            requirements: [
                .same(password)
            ]
        )
        switch result {
        case .valid: return nil
        case .invalid(let failed): return failed.first
        }
    }

    public func validate(playlistName: String) -> ValidatorRequirement? {
        let result = validator.validate(
            playlistName,
            requirements: [
                .minimumLength(1),
                .maximumLength(80)
            ]
        )
        switch result {
        case .valid: return nil
        case .invalid(let failed): return failed.first
        }
    }
}
