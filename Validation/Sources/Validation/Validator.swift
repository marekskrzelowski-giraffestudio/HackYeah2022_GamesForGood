public protocol Validator {
    func validate(_ input: String, requirements: [ValidatorRequirement]) -> ValidatorResult
}

public class DefaultValidator: Validator {
    public init() { }

    public func validate(_ input: String, requirements: [ValidatorRequirement]) -> ValidatorResult {
        let failedRequirements = requirements.filter { !$0.validate(input) }
        return failedRequirements.isEmpty ? .valid : .invalid(failed: failedRequirements)
    }
}
