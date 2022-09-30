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
        subcommands: [Search.self, WhoAmI.self])

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

    struct WhoAmI: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "whoami",
            abstract: "display your Contacts 'Me' card.")
        
        func run() async throws {
            let selectedKeys = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
            let whoAmI: CNContact

            do {
                whoAmI = try CNContactStore().unifiedMeContactWithKeys(toFetch: selectedKeys )
            } catch {
                print("Could not fetch contact.")
                return
            }
            guard let myName = CNContactFormatter.string(from: whoAmI, style: .fullName) else {
                print("Coudn't format name.")
                return
            }
            print(myName)
            print("done.")
        }
    }
}
 

extension Contacts {
    struct Search: AsyncParsableCommand {
        func run() async throws {
  
        }
    }
}











