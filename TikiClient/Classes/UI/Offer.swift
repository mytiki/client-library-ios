/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import SwiftUI

/// An Offer for creating a License for a Title identified by [ptr].
public class Offer {
    /// An image that represents the reward.
    ///
    /// It should have 300x86 size and include assets for all screen depths.
   
    
    /// The bullets that describes how the user data will be used.
    
    /// The Pointer Record of the data stored.
    
    /// A human-readable description for the license.
    
    /// The legal terms of the offer.
    
    /// The Use cases for the license.
    
    /// The tags that describes the represented data asset.
    
    /// The expiration of the License. Null for no expiration.
    
    /// A list of device-specific [Permission] required for the license.
    
    public var _id: String?
    public var ptr: String?
    public var description: String?
    public var terms: String?
    public var reward = [Reward]()
    public var use: Use
    public var tags = [Tag]()
    public var permissions = [Permission?]()
    
    
    public init(_id: String? = nil, ptr: String? = nil, description: String? = nil, terms: String? = nil, reward: [Reward] = [Reward](), use: Use, tags: [Tag] = [Tag](), permissions: [Permission?] = [Permission?]()) {
        self._id = _id
        self.ptr = ptr
        self.description = description
        self.terms = terms
        self.reward = reward
        self.use = use
        self.tags = tags
        self.permissions = permissions
    }
    
    /// The Offer unique identifier. If none is set, it creates a random UUID.
    public var id: String {
        if(_id == nil){
            _id = UUID().uuidString
        }
        return _id!
    }
    
    /// Sets the [id]
    public func id(_ id: String) -> Offer {
        _id = id
        return self
    }
    
    /// Sets the [reward]
    public func reward(_ reward: [Reward]) -> Offer {
        self.reward = reward
        return self
    }
    
    /// Sets the [ptr]
    public func ptr(_ ptr: String) -> Offer {
        self.ptr = ptr
        return self
    }
    
    /// Sets the [description]
    public func description(_ description: String?) -> Offer {
        self.description = description
        return self
    }
    
    /// Sets the [terms]
    public func terms(_ filename: String) throws -> Offer {
        terms = try String(
            contentsOfFile: Bundle.main.path(forResource: filename, ofType: "md")!,
            encoding: String.Encoding(rawValue: NSUTF8StringEncoding))
        return self
    }
    
    /// Adds an item in the [uses] list.
    public func use(usecases: [Usecase], destinations: [String]? = []) -> Offer {
        self.use = Use(usecases: usecases, destinations: destinations)
        return self
    }
    
    /// Adds an item in the [tags
    public func tag(_ tag: Tag) -> Offer {
        tags.append(tag)
        return self
    }
    
    /// Adds an item in the [requiredPermissions] list.
    public func permission(_ permission: Permission) -> Offer {
        permissions.append(permission)
        return self
    }
    
}
