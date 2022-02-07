//
//  ContentView.swift
//  UserList
//
//  Created by JOSEPH KERR on 2/7/22.
//

import SwiftUI


@MainActor
class ViewModel: ObservableObject {
    @Published var users: Users = []
    
    private var userService: WebService = UserService()
    
    init() {
        userService.fetch {
            switch $0 {
            case .success(let users):
                if #available(iOS 15, *) {
                    Task {
                        await MainActor.run {
                            self.users = users
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.users = users
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}


@available(iOS 15, *)
@MainActor
class UsersViewModel: ObservableObject {
    @Published var users: Users = []
    
    init() {
        Task {
            let result = await UserWebService.fetchUsers()
            switch result {
            case .success(let users):
                Task {
                    await MainActor.run {
                        self.users = users
                    }
                }
            case .failure(let error):
                print(error)
            }
            self.users = users
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = UsersViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.users, id: \.id) { user in
                    Text("\(user.name)\(user.address.geo.lat) \(user.address.geo.lng)")
                        .font(.title)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
