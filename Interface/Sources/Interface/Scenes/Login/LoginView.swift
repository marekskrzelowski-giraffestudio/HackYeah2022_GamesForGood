import Content
import SwiftUI

struct LoginView: View {
    private enum Input: Int, Hashable {
        case email, password
    }

    @StateObject var viewModel: LoginViewModel
    @FocusState private var focusedInput: Input?

    var body: some View {
        VStack(spacing: 0) {
            logo
            Spacer()
            inputs
            Spacer()
            loginButton
        }
        .padding(.top, 50)
        .padding(.bottom, 39)
        .padding(.horizontal, 20)
    }

    var logo: some View {
        VStack(spacing: 10) {
            Content.image(.logoimage)
            Content.image(.logotext)
        }
    }

    var inputs: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Email Address")
                    .font(.custom("Rubik-Medium", size: 16))
                ZStack {
                    HStack {
                        Content.image(.mail)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    InputTextField(
                        type: .emailAddress,
                        secure: false,
                        text: $viewModel.email,
                        placeholder: "Enter email",
                        error: viewModel.emailError
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Content.color(.blackBlack), lineWidth: 1)
                    )
                    .focused($focusedInput, equals: .email)
                    .onChange(of: viewModel.email, perform: { viewModel.validate(email: $0) })
                    .onSubmit {
                        viewModel.validate(email: viewModel.email)
                        focusedInput = .password
                    }
                }
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Password")
                    .font(.custom("Rubik-Medium", size: 16))
                ZStack {
                    HStack {
                        Content.image(.lock)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    InputTextField(
                        type: .default,
                        secure: true,
                        text: $viewModel.password,
                        placeholder: "Enter password",
                        error: viewModel.passwordError
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Content.color(.blackBlack), lineWidth: 1)
                    )
                    .focused($focusedInput, equals: .password)
                    .onChange(of: viewModel.password, perform: { viewModel.validate(password: $0) })
                    .onSubmit {
                        viewModel.validate(password: viewModel.password)
                        focusedInput = nil
                    }
            }
            }
        }
    }

    var loginButton: some View {
        PrimaryButton(text: Content.copy("Login")) {
            focusedInput = nil
            viewModel.submit()
        }
    }
}
