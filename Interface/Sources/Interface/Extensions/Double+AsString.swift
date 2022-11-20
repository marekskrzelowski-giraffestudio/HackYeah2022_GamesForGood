extension Double {
    var asPercentString: String {
        let formatedDouble = String(format: "%.0f", self * 100)
        return "\(formatedDouble)%"
    }
}
