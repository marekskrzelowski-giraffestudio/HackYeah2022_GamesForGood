public enum ValidatorResult {
    case valid
    case invalid(failed: [ValidatorRequirement])
}
