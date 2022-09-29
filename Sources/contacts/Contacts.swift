// 
// Contacts.swift - 
// 

import ArgumentParser
import Contacts
import Foundation

@main
struct Contacts: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Command line interface for 🍎Contacts.",
        subcommands: [Search.self])

     func run() async throws {
        switch CNContactStore.authorizationStatus(for: CNEntityType.contacts) {
        case .authorized: print("authorized")
        case .notDetermined: print("undetermined")
        case .restricted: print("restricted")
        case .denied: print("denied")
        default: print("completly unknown") // needed but probably not used
        }
    }
}


struct Options: ParsableArguments {
}


extension Contacts {
    struct Search: AsyncParsableCommand {
        @Argument var searchString: String

        func run() async throws {
            let cStore = CNContactStore()

            print("This is the search command.")
        }
    }
}
        













