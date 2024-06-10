import Foundation

struct Article: Identifiable, Hashable {
    let id = UUID().uuidString
    let title: String
    let subTitle: String
    let image: String
    let cost: Double
    var count: Int
    var isDigital: Bool
}

extension Article {
    static let articles = [
        Article(title: "Курс Английского", subTitle: "", image: "english", cost: 1.00, count: 0, isDigital: true),
        Article(title: "Футболка", subTitle: "", image: "shirt", cost: 1.0, count: 0, isDigital: false)
    ]
}
