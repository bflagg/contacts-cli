// Contacts.swift - A Command Line tool to
/*
Copyright © 2020 brian flagg <bflagg@acm.org>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.
 */

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
    }
}

struct Options: ParsableArguments {
}


extension Contacts {

    struct WhoAmI: AsyncParsableCommand {
        static var configuration = CommandConfiguration(commandName: "whoami", abstract: "Display your Contacts 'Me' record.")

        func run() async throws {
            let keysToFetch: [CNKeyDescriptor] = [ CNContactVCardSerialization.descriptorForRequiredKeys(), ]

            let myContact = try CNContactStore().unifiedMeContactWithKeys(toFetch: keysToFetch)
            let myName = CNContactFormatter.string(from: myContact, style: .fullName)
            let myPhones = myContact.phoneNumbers
            let myEmails = myContact.emailAddresses
            let myOrg = myContact.organizationName

            print(myName ?? "Noname, Uno")
            print("☎️ \(myPhones.count)")
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











