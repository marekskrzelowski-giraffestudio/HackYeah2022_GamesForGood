import Networking
import Validation
import Persistence
import Core

@MainActor class Dependencies {
    let validatorService: ValidatorService
    let userService: UserService
    let authService: AuthService
    let missionsService: MissionsService

    init() {
        let validator = DefaultValidator()
        let secureStorage = SecureStorage()
        let defaultsStorage = DefaultsStorage()
        let memoryStorage = MemoryStorage()
        let baseNetworking = DefaultNetworking()
        authService = DefaultAuthService(
            networking: baseNetworking,
            secureStorage: secureStorage,
            defaultsStorage: defaultsStorage,
            memoryStorage: memoryStorage
        )
        let authorizedNetworking = DefaultNetworking(
            requestModifiers: [AccessTokenInserter(storage: secureStorage)],
            errorHandler: UnauthorizedErrorHandler(authService: authService)
        )
        validatorService = DefaultValidatorService(
            validator: validator
        )
        userService = DefaultUserService(
            networking: authorizedNetworking,
            defaultsStorage: defaultsStorage,
            memoryStorage: memoryStorage
        )
        missionsService = DefaultMissionService(
            networking: authorizedNetworking,
            storage: defaultsStorage
        )
    }
}
