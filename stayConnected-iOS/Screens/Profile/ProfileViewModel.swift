//
//  ProfileViewModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 01.12.24.
//

import Foundation

protocol AvatarDelegate: AnyObject {
    func didAvatarChanged()
}

final class ProfileViewModel {
    weak var delegate: AvatarDelegate?
    
    private let avatarsArray = [
        "Eden",
        "Sadie",
        "Sara",
        "Oliver",
        "Mason",
        "Amaya",
        "Alexander",
        "Jameson",
        "Brian",
        "Brooklynn",
        "Aiden",
        "Sawyer",
        "Sophia",
        "Destiny",
        "Kingston",
        "Caleb",
        "Chase",
        "Aidan",
        "Adrian",
        "Leo"
    ]
    
    var avatarName: String = ""
    
    var avatarsCount: Int {
        avatarsArray.count
    }
    
    func singleAvatar(at index: Int) -> String {
        avatarsArray[index]
    }
    
    func setAvatar(with name: String) {
        UserDefaults.standard.set(name, forKey: "userAvatar")
        avatarName = name
        self.delegate?.didAvatarChanged()
    }
}
