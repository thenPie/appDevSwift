import Foundation
protocol NetworkServiceProtocol {
    func getFriends(completion: @escaping(Result<[Friend], Error>) -> Void)
    func getGroups(completion: @escaping(Result<[Group], Error>) -> Void)
    func getPhotos(completion: @escaping ([Photo]) -> Void)
    func getProfileInfo(completion: @escaping (Profile) -> Void)
}
final class NetworkService: NetworkServiceProtocol {
    private let session = URLSession.shared
    static var token = ""
    enum NetworkError: Error {
        case urlError
        case dataError
    }
    func getFriends(completion: @escaping(Result<[Friend], Error>) -> Void) {
        guard let url = URL(string: "https://api.vk.com/method/friends.get?access_token=" + NetworkService.token + "&fields=photo_50,online&v=5.199") else {
            completion(.failure(NetworkError.urlError))
            return
        }
        session.dataTask(with: url) { (data, _, error) in
            guard let data else {
                completion(.failure(NetworkError.dataError))
                return
            }
            if let error {
                completion(.failure(error))
                return
            }
            do {
                let friends = try JSONDecoder().decode(FriendsModel.self, from: data)
                completion(.success(friends.response.items))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    func getGroups(completion: @escaping(Result<[Group], Error>) -> Void) {
        guard let url = URL(string: "https://api.vk.com/method/groups.get?access_token=" + NetworkService.token + "&extended=1&fields=description&v=5.199") else {
            completion(.failure(NetworkError.urlError))
            return
        }
        session.dataTask(with: url) { (data, _, error) in
            guard let data else {
                completion(.failure(NetworkError.dataError))
                return
            }
            if let error {
                completion(.failure(error))
                return
            }
            do {
                let groups = try JSONDecoder().decode(GroupsModel.self, from: data)
                completion(.success(groups.response.items))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    func getPhotos(completion: @escaping ([Photo]) -> Void) {
        guard let url = URL(string: "https://api.vk.com/method/photos.get?access_token=" + NetworkService.token + "&album_id=wall&v=5.199") else {
            return
        }
        session.dataTask(with: url) { (data, _, networkError) in
            guard let data else {
                return
            }
            do {
                let photos = try JSONDecoder().decode(PhotosModel.self, from: data)
                completion(photos.response.items)
            } catch {
                print(error)
            }
        }.resume()
    }
    func getProfileInfo(completion: @escaping (Profile) -> Void) {
        guard let url = URL(string: "https://api.vk.com/method/account.getProfileInfo?access_token=" + NetworkService.token + "&v=5.199") else {
            return
        }
        session.dataTask(with: url) { (data, _, networkError) in
            guard let data else {
                return
            }
            do {
                let profile = try JSONDecoder().decode(ProfileModel.self, from: data)
                completion(profile.response)
            } catch {
                print(error)
            }
        }.resume()
    }
}