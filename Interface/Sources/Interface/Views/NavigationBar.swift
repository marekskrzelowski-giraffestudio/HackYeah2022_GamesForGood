import SwiftUI
import Content

struct NavigationBar: View {
    enum TitleSize {
        case small, normal
    }
    let titleKey: String
    let titleSize: TitleSize
    let leftImage: Image?
    let leftImageColor: Color?
    let leftAction: (() -> Void)?
    let rightTitle: String?
    let rightImage: Image?
    let rightImageColor: Color?
    let rightAction: (() -> Void)?
    let backgroundColor: Color

    init(
        titleKey: String,
        titleSize: TitleSize = .normal,
        leftImage: Image? = nil,
        leftImageColor: Color? = nil,
        leftAction: (() -> Void)? = nil,
        rightTitle: String? = nil,
        rightImage: Image? = nil,
        rightImageColor: Color? = nil,
        rightAction: (() -> Void)? = nil,
        backgroundColor: Color = Content.color(.blackBlack)
    ) {
        self.titleKey = titleKey
        self.titleSize = titleSize
        self.leftImage = leftImage
        self.leftImageColor = leftImageColor
        self.leftAction = leftAction
        self.rightTitle = rightTitle
        self.rightImage = rightImage
        self.rightImageColor = rightImageColor
        self.rightAction = rightAction
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        ZStack {
            HStack {
                if let leftImage = leftImage {
                    leftImage
                        .resizable()
                        .frame(width: 26, height: 26)
                        .foregroundColor(leftImageColor)
                        .onTapGesture(perform: leftAction ?? { })
                }
                Spacer()
                if let rightTitle = rightTitle {
                    Text(rightTitle)
                        .frame(alignment: .center)
                        .foregroundColor(rightImageColor)
                        .onTapGesture(perform: rightAction ?? { })
                }
                if let rightImage = rightImage {
                    rightImage
                        .resizable()
                        .frame(width: 26, height: 26)
                        .foregroundColor(rightImageColor)
                        .onTapGesture(perform: rightAction ?? { })
                }
            }
            Text(Content.copy(titleKey))
                .font(titleFont)
                .foregroundColor(Content.color(.blackWhite))
        }
        .frame(height: 51)
        .background(backgroundColor)
    }

    private var titleFont: Font {
        switch titleSize {
        case .small:
            return .system(size: 14, weight: .semibold)
        case .normal:
            return .system(size: 18, weight: .regular)
        }
    }
}
