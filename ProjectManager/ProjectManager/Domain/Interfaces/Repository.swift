//
//  Repository.swift
//  ProjectManager
//
//  Created by JINHONG AN on 2021/11/11.
//

import Foundation

protocol DataGettableRepository {
    associatedtype Entity: Codable
    func fetch(completion: @escaping (Result<[Entity], Error>) -> Void)
}

protocol DataModifiableRepository: DataGettableRepository {
    func add(memo: Entity, completion: @escaping (Result<Entity, Error>) -> Void)
    func delete(memo: Entity, completion: @escaping (Result<Entity, Error>) -> Void)
    func update(memo: Entity, completion: @escaping (Result<Entity, Error>) -> Void)
}
