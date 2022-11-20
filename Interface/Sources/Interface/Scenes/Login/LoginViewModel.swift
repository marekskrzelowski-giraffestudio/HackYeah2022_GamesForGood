import Foundation
import Content
import Networking

final class LoginViewModel: BaseViewModel {
    @Published var email: String = ""
    @Published var emailError: String?
    @Published var password: String = ""
    @Published var passwordError: String?
    private var inputCorrect: Bool {
        emailError == nil && passwordError == nil
    }

    func submit() {
        validate(email: email)
        validate(password: password)
        guard inputCorrect else { return }
        modal?.show(.loading)
        Task {
            do {
                try await dependencies.authService.login(email: email, password: password)
                modal?.hide()
            } catch let error as NetworkingError {
                modal?.show(.error(message: error.message))
            } catch {
                modal?.show(.error(message: nil))
            }
        }
    }

    func validate(email: String) {
        emailError = email.isEmpty ? Content.copy("Please enter email") : nil
    }

    func validate(password: String) {
        passwordError = password.isEmpty ? Content.copy("Please enter password") : nil
    }
}
