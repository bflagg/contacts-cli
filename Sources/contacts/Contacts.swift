// 
// Contacts.swift - 
// 

import ArgumentParser
import Contacts
import Foundation

@main
struct Contacts: AsyncParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Command line interface for 🍎Contacts.", subcommands: [Search.self, WhoAmI.self])

    mutating func run() async throws {
        let stat = CNContactStore.authorizationStatus(for: .contacts)
        switch stat {
        case .authorized: print("authorized")
        case .denied: print("denied")
        case .restricted: print("restricted")
        case .notDetermined: print("not determined")
        default: print("fatal error.")
        }
    }
}

struct Options: ParsableArguments {
}


extension Contacts {

    struct WhoAmI: AsyncParsableCommand {
        static var configuration = CommandConfiguration(commandName: "whoami", abstract: "Display your Contacts 'Me' card.")

        func run() async throws {
            let selectedKeys = CNContactFormatter.descriptorForRequiredKeys(for: .fullName)
            let whoAmI: CNContact
            do {
                whoAmI = try CNContactStore().unifiedMeContactWithKeys(toFetch: [selectedKeys])
            } catch {
                print("Could not fetch contact.")
                return
            }
            let myName = CNContactFormatter.string(from: whoAmI, style: .fullName)

            print(myName ?? "Noname, Uno")
            print("done.")
        }
    }
}
 
extension Contacts {
    struct Search: AsyncParsableCommand {
        static var configuration = CommandConfiguration(commandName: "search", abstract: "Search your contacts.")

        @Argument(help: "The search query Name.")
        var qName:String

        func run() async throws {
            let selectedKeys = CNContactFormatter.descriptorForRequiredKeys(for: .fullName)
            let selectedContacts = CNContact.predicateForContacts(matchingName: qName)
            let results: [CNContact]
            do {
                results = try CNContactStore().unifiedContacts(matching: selectedContacts, keysToFetch: [selectedKeys])
            } catch {
                print("Could not fetch contact.")
                return
            }

            for result in results {
                let tmpName = CNContactFormatter.string(from: result, style: .fullName)
                print(tmpName ?? "Noname, Uno")
            }

            print("done.")
        }
    }
}











