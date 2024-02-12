struct GroupsModel: Decodable {
    let response: GroupsItems
}
struct GroupsItems: Decodable {
    let items: [Group]
}
struct Group: Decodable {
    let id: Int
    let name: String
    let description: String?
    let photo: String
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case photo = "photo_50"
    }
}