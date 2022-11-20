import SwiftUI
import Content

struct UIPickerViewRepresentable: UIViewRepresentable {
    private let data: [[String]] = [
        Array(0...23).map(\.description),
        Array(0...59).map(\.description),
        Array(0...59).map(\.description)
    ]
    private var selections: [Int]
    @Binding var secondsSet: TimeInterval

    init(secondsSet: Binding<TimeInterval>) {
        _secondsSet = secondsSet
        selections = [
            Int(secondsSet.wrappedValue / 3600),
            Int(secondsSet.wrappedValue.truncatingRemainder(dividingBy: 3600) / 60),
            Int(secondsSet.wrappedValue.truncatingRemainder(dividingBy: 60))
        ]
    }

    func makeCoordinator() -> UIPickerViewRepresentable.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<UIPickerViewRepresentable>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<UIPickerViewRepresentable>) {
        selections.indices.forEach { index in
            view.selectRow(selections[index], inComponent: index, animated: false)
        }
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: UIPickerViewRepresentable

        init(_ pickerView: UIPickerViewRepresentable) {
            parent = pickerView
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            parent.data.count
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            parent.data[component].count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            parent.data[component][row]
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.selections[component] = row
            parent.secondsSet = TimeInterval(
                (parent.selections[0] * 3600) + (parent.selections[1] * 60) + (parent.selections[2])
            )
        }

        func pickerView(
            _ pickerView: UIPickerView,
            attributedTitleForRow row: Int,
            forComponent component: Int
        ) -> NSAttributedString? {
            .init(
                string: parent.data[component][row],
                attributes: [
                    .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                    .foregroundColor: UIColor(Content.color(.blackWhite))
                ]
            )
        }
    }
}
