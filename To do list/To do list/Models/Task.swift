import Foundation
import SwiftUI
import CoreLocation
import RealmSwift

class Task: Object, Identifiable {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var title: String
    @Persisted var descriptionText: String
    @Persisted var isCompleted: Bool
    
    convenience init(id: UUID = UUID(), title: String, description: String, isCompleted: Bool = false) {
        self.init()
        self.id = id
        self.title = title
        self.descriptionText = description
        self.isCompleted = isCompleted
    }
    
    override var description: String {
        return descriptionText
    }
}
