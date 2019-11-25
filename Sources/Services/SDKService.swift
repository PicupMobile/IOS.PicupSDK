//
//  SDKService.swift
//  PICUP_SDK
//
//  Created by Admin on 19.11.2019.
//  Copyright © 2019 ItWorksinUA. All rights reserved.
//

import AddressBook
import Contacts
import Foundation
import UIKit

// MARK: - PullMessageData
public struct PCUSDKUser {
    public var phoneNumber: String
    public var name: String
    public var token: String
    public var appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    public var sdkVersion = "1.0.6"
    public var deviceName = "iPhone"
    public var deviceModel = "iPhone"
    public var osVersion = UIDevice.current.systemVersion
    public var screenSize = "\(UIScreen.main.bounds.size.height)x\(UIScreen.main.bounds.size.width)"
    public var screenDensity = "420"
    public var mode = "Waked ( On App )"
    public var permission = "1,1,0,1,1"
    public var serviceEnabled = "true"
    public var organizationCode = "555"
    public var serviceCode = "12345"

    public init(phoneNumber: String, name: String, token: String, organizationCode: String, serviceCode: String) {
        self.phoneNumber = phoneNumber
        self.name = name
        self.token = token
        self.organizationCode = organizationCode
        self.serviceCode = serviceCode
    }
}

open class SDKService {
    public static let shared = SDKService()

    public func getData(_ user: PCUSDKUser, finalBlock: @escaping (String?) -> Void) {
//        guard let _ = user.token, let _ = user.organizationCode, let _ = user.serviceCode, let _ = user.phoneNumber, let _ = user.name else {
//            finalBlock("Token, Organization Code, Service code, Phoine number, Name reuired")
//            return
//        }
        NetworkService.shared.deviceToken = user.token
        NetworkService.shared.organizationCode = user.organizationCode
        NetworkService.shared.getSessionToken (user.serviceCode, completion: { err in
            if let err = err {
                finalBlock(err.localizedDescription)
                return
            }
            NetworkService.shared.registerClientDevice(phoneNumber: user.phoneNumber, name: user.name) { dev, err in
                if let err = err {
                    finalBlock(err.localizedDescription)
                    return
                }
                NetworkService.shared.pullMessageData(status: "App. version: \(user.appVersion!) \nSDK version: \(user.sdkVersion) \nDevice name: \(user.deviceName) \nDevice model: \(user.deviceModel) \nOS version: \(user.osVersion) \nScreen size: \(user.screenSize) \nScreen density: \(user.screenDensity) \nMode: \(user.mode) \nPermissions: \(user.permission) \nService enabled: \(user.serviceEnabled)") { data, err in
                    if let err = err {
                        finalBlock(err.localizedDescription)
                        return
                    }
                    let worker = CNWorker(nil)
                    worker.requestForAccess { success in
                        if let group = worker.makeGroup() {
                            if let persons = data?.pullMessageData?.campaignsData {
                                for person in persons {
                                    let newContact = CNMutableContact()
                                    newContact.givenName = person.name ?? ""
                                    newContact.organizationName = person.dispText ?? ""
                                    newContact.departmentName = person.dispName ?? ""
                                    let urlStr = "https://picup-server-sdk-v2.appspot.com" + "\(person.imageURL!)"
                                    if let url = URL(string: urlStr), let imgData = try? Data(contentsOf: url) {
                                        if let image = UIImage(data: imgData) {
                                            newContact.imageData = image.pngData()
                                        }
                                    }
                                    // newContact.note = "PICUP SDK"
                                    newContact.phoneNumbers = [CNLabeledValue(
                                        label: CNLabelPhoneNumberiPhone,
                                        value: CNPhoneNumber(stringValue: person.backNumber!)
                                    )]
                                    do {
                                        let saveRequest = CNSaveRequest()
                                        saveRequest.add(newContact, toContainerWithIdentifier: worker.curContainer?.identifier)
                                        saveRequest.addMember(newContact, to: group)
                                        try worker.contactStore.execute(saveRequest)
                                    } catch {}
                                    finalBlock(nil)
                                }
                            }
                        }
                    }
                }
            }
        })
    }
}
