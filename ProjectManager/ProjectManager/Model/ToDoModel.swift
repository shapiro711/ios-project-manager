//
//  ToDoModel.swift
//  ProjectManager
//
//  Created by JINHONG AN on 2021/11/04.
//

import Foundation

struct ToDoModel {
    private(set) var toDos: [[ToDo]] = [[], [], []]
    private(set) var toDoType: [ToDoStatus] = [.toDo, .doing, .done]
    
    mutating func add(_ toDo: ToDo) {
        toDos[0].append(toDo)
    }
    
    mutating func delete(column: Int, row: Int) {
        toDos[column].remove(at: row)
    }
    
    mutating func move(oldColumn: Int, oldRow: Int, to newColumn: Int) {
        let target = toDos[oldColumn].remove(at: oldRow)
        toDos[newColumn].append(target)
    }
}
