// 
// Contacts.swift - 
//
//   import SafariServices
//  SFSafariServicesAvailable(.version13_0)
//
//
//
//
import ArgumentParser
import Contacts
import Foundation


@main
struct Contacts: AsyncParsableCommand {
    @Flag var verbose = false
    
    static var configuration = CommandConfiguration(abstract: "Command line interface for 🍎Contacts.", subcommands: [Search.self, WhoAmI.self])
    
    mutating func run() async throws {
        let stat = CNContactStore.authorizationStatus(for: .contacts)
        switch stat {
            case .notDetermined:
                print("not determined")
            case .restricted:
                print("restricted")
            case .denied:
                print("denied")
            case .authorized:
                print("authorized")
            default: print("probably a fatal error?")
        }
        
        guard let containers = try? CNContactStore().containers(matching: nil) else {
            return
        }

        print(containers)
    }
}

struct Options: ParsableArguments {
}


extension Contacts {

    struct WhoAmI: AsyncParsableCommand {
        static var configuration = CommandConfiguration(commandName: "whoami", abstract: "Display your Contacts 'Me' card.")

        func run() async throws {
            let keysToFetch: [CNKeyDescriptor] = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactOrganizationNameKey as CNKeyDescriptor,
                CNContactEmailAddressesKey as CNKeyDescriptor,
            ]
            
            let myContact = try CNContactStore().unifiedMeContactWithKeys(toFetch: keysToFetch)
            let myName = CNContactFormatter.string(from: myContact, style: .fullName)
            let myPhones = myContact.phoneNumbers
            let myEmails = myContact.emailAddresses
            let myOrg = myContact.organizationName

            print(myName ?? "Noname, Uno")
            print("☎ \(myPhones.count)")
            print("📧 \(myEmails.count)")
            print("🏢 \(myOrg)")
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
            let results = try CNContactStore().unifiedContacts(matching: selectedContacts, keysToFetch: [selectedKeys])

            for result in results {
                let tmpName = CNContactFormatter.string(from: result, style: .fullName)
                print(tmpName ?? "Noname, Uno")
            }

            print("done.")
        }
    }
}











