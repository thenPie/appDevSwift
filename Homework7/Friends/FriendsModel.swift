struct FriendsModel: Decodable {
    let response: FriendsItems
}
struct FriendsItems: Decodable {
    let items: [Friend]
}
struct Friend: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let photo: String
    let online: Int
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo = "photo_50"
        case online
    }
}