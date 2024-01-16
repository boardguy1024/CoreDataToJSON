//
//  Purchase+CoreDataClass.swift
//  CoreDataToJSON
//
//  Created by paku on 2024/01/16.
//
//

import Foundation
import CoreData

enum ContextError: Error {
    case NoFoundContext
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

@objc(Purchase)
public class Purchase: NSManagedObject, Identifiable, Codable {
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var dateOfPurchase: Date?
    @NSManaged public var amountSpent: Double
    
    enum CodingKeys: CodingKey {
        case id, title, dateOfPurchase, amountSpent
    }
    
    public required convenience init(from decoder: Decoder) throws {
        // codableを準拠するには、decodable, encodableを実装する必要がある
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            throw ContextError.NoFoundContext
        }
        // NSManagedObjectのinit
        self.init(context: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        dateOfPurchase = try values.decode(Date.self, forKey: .dateOfPurchase)
        amountSpent = try values.decode(Double.self, forKey: .amountSpent)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(dateOfPurchase, forKey: .dateOfPurchase)
        try container.encode(amountSpent, forKey: .amountSpent)
    }
}
