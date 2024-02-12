import Foundation
import CoreData
extension FriendsDate {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendsDate> {
        return NSFetchRequest<FriendsDate>(entityName: "FriendsDate")
    }
    @NSManaged public var date: Date?
}
extension FriendsDate : Identifiable {
}