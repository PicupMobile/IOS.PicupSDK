import Foundation

// MARK: - SessionToken
public struct SessionToken: BaseResponse, Codable {
    public let status: Status?
    public let token: String?
    
    
    enum CodingKeys: String, CodingKey {
        case status
        case token
    }
    
    public init(status: Status?, token: String?) {
        self.status = status
        self.token = token
    }
}
