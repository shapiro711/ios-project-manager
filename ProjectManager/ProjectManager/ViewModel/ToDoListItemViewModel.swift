//
//  ToDoListItemViewModel.swift
//  ProjectManager
//
//  Created by Kim Do hyung on 2021/11/03.
//

import Foundation

struct ToDoListItemViewModel: Equatable, Identifiable {
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var id = UUID()
    var title: String
    var description: String
    var date: TimeInterval
    var status: ToDoStatus
}

extension ToDoListItemViewModel {

    init(toDo: ToDo) {
        self.title = toDo.title
        self.description = toDo.description
        self.status = toDo.status
        self.date = toDo.date
        self.status = toDo.status
    }
}
