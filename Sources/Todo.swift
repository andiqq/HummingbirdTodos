import Foundation
import Hummingbird

struct Todo {
    var id: UUID
    var title: String
    var order: Int?
    var url: String
    var completed: Bool?
}

extension Todo: ResponseEncodable, Decodable, Equatable {}
