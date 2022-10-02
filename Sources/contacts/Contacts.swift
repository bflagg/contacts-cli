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
        switch CNContactStore.authorizationStatus(for: .contacts) {
            case .notDetermined: print("not determined")
            case .restricted: print("restricted")
            case .denied: print("denied")
            case .authorized: print("authorized")
            default: print("This should be a fatal error, i think.")
        }
        
        if try await CNContactStore().requestAccess(for: .contacts) {
            print("true")
        } else {
            print("false")
        }
    }
}

struct Options: ParsableArguments {
}


extension Contacts {

    struct WhoAmI: AsyncParsableCommand {
        static var configuration = CommandConfiguration(commandName: "whoami", abstract: "display your Contacts 'Me' card.")

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
 
/*
 let fullName = CNContactFormatter.string(from: contact, style: .fullName)
 print("\(String(describing: fullName))")

 
 
 
 
 let store = CNContactStore()
 do {
     let predicate = CNContact.predicateForContacts(matchingName: "Appleseed")
     let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
     print("Fetched contacts: \(contacts)")
 } catch {
     print("Failed to fetch contact, error: \(error)")
     // Handle the error
 }

 */

extension Contacts {
    struct Search: AsyncParsableCommand {
        func run() async throws {
  
        }
    }
}











