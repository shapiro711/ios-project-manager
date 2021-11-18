//
//  MemoUseCase.swift
//  ProjectManager
//
//  Created by Kim Do hyung on 2021/11/09.
//

import Foundation

protocol UseCase {
    typealias Completion = (Result<Memo, Error>) -> Void
    func add(_ memo: Memo, completion: @escaping Completion)
    func modify(_ memo: Memo, completion: @escaping Completion)
    func delete(_ memo: Memo, completion: @escaping Completion)
    func fetch(completion: @escaping (Result<[Memo], Error>) -> Void)
}

class MemorizeUseCase<Repository: DataModifiableRepository>: UseCase where Repository.Entity == Memo {
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }

    func add(_ memo: Memo, completion: @escaping Completion) {
        repository.add(memo: memo) { (result: Result<Repository.Entity, Error>) in
            switch result {
            case .success(let memo):
                completion(.success(memo))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func modify(_ memo: Memo, completion: @escaping Completion) {
        repository.update(memo: memo) { (result: Result<Repository.Entity, Error>) in
            switch result {
            case .success(let memo):
                completion(.success(memo))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func delete(_ memo: Memo, completion: @escaping Completion) {
        repository.delete(memo: memo) { (result: Result<Repository.Entity, Error>) in
            switch result {
            case .success(let memo):
                completion(.success(memo))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetch(completion: @escaping (Result<[Memo], Error>) -> Void) {
        repository.fetch { (result: Result<[Repository.Entity], Error>) in
            switch result {
            case .success(let memos):
                completion(.success(memos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

final class MemoUseCase: MemorizeUseCase<MemoRepository> {
    override init(repository: MemoRepository = MemoRepository()) {
        super.init(repository: repository)
    }
}
