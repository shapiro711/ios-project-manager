//
//  HistoryUseCase.swift
//  ProjectManager
//
//  Created by JINHONG AN on 2021/11/14.
//

import Foundation

protocol HistoryUseCaseable {
    func fetch(completion: @escaping (Result<[History], Error>) -> Void)
}

class HistoricalUseCase<Repository: DataGettableRepository>: HistoryUseCaseable where Repository.Entity == History {
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func fetch(completion: @escaping (Result<[Repository.Entity], Error>) -> Void) {
        repository.fetch { (result: Result<[Repository.Entity], Error>) in
            switch result {
            case .success(let histories):
                completion(.success(histories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

final class HistoryUseCase: HistoricalUseCase<HistoryRepository> {
    override init(repository: HistoryRepository = HistoryRepository()) {
        super.init(repository: repository)
    }
}
