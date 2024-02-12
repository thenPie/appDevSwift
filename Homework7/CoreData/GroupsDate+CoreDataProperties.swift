import Foundation
import CoreData
extension GroupsDate {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupsDate> {
        return NSFetchRequest<GroupsDate>(entityName: "GroupsDate")
    }
    @NSManaged public var date: Date?
}
extension GroupsDate : Identifiable {
}