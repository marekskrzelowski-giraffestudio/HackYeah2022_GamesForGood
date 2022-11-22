import Content
import SwiftUI

struct InputTextField: View {
    let type: UIKeyboardType
    let secure: Bool
    let text: Binding<String>
    let placeholder: String
    let error: String?
    @FocusState private var isFocued: Bool
    private var displayError: Bool { error != nil && !isFocued }
    private var placeholderTransition: Bool { isFocued || !text.wrappedValue.isEmpty }
    private var textTransition: Bool { placeholderTransition || error != nil }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack(alignment: .leading) {
                Text(displayError ? error ?? "" : "")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.system(size: textTransition ? 14 : 16, weight: .regular))
                    .foregroundColor(
                        Content.color(
                            displayError ?
                                .statusError :
                                placeholderTransition ? .blackBlack : .blackWhite
                        )
                    )
                    .offset(x: 0, y: textTransition ? 33 : 0)
                if secure {
                    SecureField("", text: text)
                        .keyboardType(type)
                        .focused($isFocued)
                        .font(.custom("Rubik-Regular", size: 16))
                        .foregroundColor(Content.color(.blackBlack))
                        .accentColor(Content.color(.accentNormal))
                        .disableAutocorrection(true)
                        .padding(.leading, 35)
                } else {
                    TextField("", text: text)
                        .keyboardType(type)
                        .focused($isFocued)
                        .autocapitalization(.none)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Content.color(.blackBlack))
                        .accentColor(Content.color(.accentNormal))
                        .disableAutocorrection(true)
                        .padding(.leading, 35)
                }
            }
            .padding(.bottom, 13)
        }
        .frame(height: 40)
        .onTapGesture { isFocued = true }
    }
}
