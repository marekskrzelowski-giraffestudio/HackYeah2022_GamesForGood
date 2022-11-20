import Networking

struct LoginBody: HTTPBody {
    let email: String
    let password: String
}
