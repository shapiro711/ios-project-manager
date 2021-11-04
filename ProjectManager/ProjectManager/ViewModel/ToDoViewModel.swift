//
//  ToDoViewModel.swift
//  ProjectManager
//
//  Created by JINHONG AN on 2021/11/03.
//

import Foundation

final class ToDoViewModel: ObservableObject {
    @Published private(set) var toDoModel = ToDoModel()
    
    func add(_ toDo: ToDo) {
        toDoModel.add(toDo)
    }
    
    func delete(column: Int, indexSet: IndexSet) {
        guard let row = indexSet.first else {
            return
        }
        toDoModel.delete(column: column, row: row)
    }
    
    func move(oldColumn: Int, oldRow: Int, to newColumn: Int) {
        toDoModel.move(oldColumn: oldColumn, oldRow: oldRow, to: newColumn)
    }
}
