//
//  PostAddViewModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import Foundation

protocol DidTagsRefreshed: AnyObject {
    func didTagsRefreshed()
}

protocol DidTagsRefreshedInactiveTags: AnyObject {
    func didTagsRefreshedInactives()
}

final class PostAddViewModel {
    weak var delegate: DidTagsRefreshed?
    weak var delegateInactiveTags: DidTagsRefreshedInactiveTags?

    var activeTags: [String] = []
    var inactiveTags: [String] = [
        "iOS",
        "Android",
        "Docker",
        "Js",
        "HTML",
        "macOS",
        "Windows",
        "Linux"
    ]

    func singleActiveTag(at index: Int) -> String {
        return activeTags[index]
    }

    func removeActiveTag(at index: Int) {
        inactiveTags.append(activeTags[index])
        activeTags.remove(at: index)
        delegateInactiveTags?.didTagsRefreshedInactives()
    }

    func singleInactiveTag(at index: Int) -> String {
        return inactiveTags[index]
    }

    func removeInactiveTag(at index: Int) {
        activeTags.append(inactiveTags[index])
        inactiveTags.remove(at: index)
        delegate?.didTagsRefreshed()
    }
    
    
    func postQuestion(subject: String, question: String) {
        print(activeTags)
        
        print(subject)
        print(question)
    }
}
