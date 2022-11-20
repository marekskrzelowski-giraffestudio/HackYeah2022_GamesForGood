import SwiftUI
import Content

struct CircularProgressView: View {
    let progress: CGFloat
    let thickness: CGFloat
    let innerSpacing: CGFloat
    let content: ContentType
    let ranges: Ranges = .init()

    public var body: some View {
        ZStack {
            GeometryReader { proxy in
                let center = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)
                let radius = min(proxy.size.width, proxy.size.height) / 2 - thickness - innerSpacing
                Path { path in
                    path.move(to: center)
                    path.addArc(center: center,
                                radius: radius,
                                startAngle: Angle(degrees: 0),
                                endAngle: Angle(degrees: innerCircleTrim * 360),
                                clockwise: false)
                }
                .fill(.clear)
                .rotationEffect(Angle(degrees: 270))
            }
            Circle()
                .trim(from: 0, to: outerCircleTrim)
                .stroke(color, style: .init(lineWidth: thickness, lineCap: .square, lineJoin: .round))
                .rotationEffect(Angle(degrees: 270))
                .padding(thickness / 2)
            switch content {
            case let .text(font):
                Text("\(Int(progress * 100))%")
                    .font(font)
                    .foregroundColor(color)
            case .tick where ranges.good.contains(progress):
                Image("tick")
                    .renderingMode(.template)
                    .foregroundColor(color)
            default:
                EmptyView()
            }

        }
    }
}

// MARK: - Types

extension CircularProgressView {
    enum ContentType {
        case text(font: Font)
        case tick
    }

    struct Ranges {
        let good = 0.75...1.0
        let normal = 0.25..<0.75
        let bad = 0..<0.25
    }
}

// MARK: - Private

extension CircularProgressView {
    private var color: Color {
        switch progress {
        default: return .white
        }
    }

    private var innerCircleTrim: CGFloat {
        switch content {
        case .text: return 1
        case .tick: return max(0, min(progress, 1))
        }
    }

    private var outerCircleTrim: CGFloat {
        switch content {
        case .text: return max(0, min(progress, 1))
        case .tick: return 1
        }
    }
}
