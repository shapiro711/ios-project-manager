//
//  ToDoViewModel.swift
//  ProjectManager
//
//  Created by Kim Do hyung on 2021/11/03.
//

import Foundation
import Combine

protocol ToDoViewModelInput {
    func addToDo(_ toDo: ToDo)
    func deleteToDo(_ toDo: ToDo)
    func editToDo(_ toDo: ToDo)
    func moveColumn(toDo: ToDo, to state: ToDoStatus)
}

protocol ToDoViewModelOutput {
    var toDos: [[ToDo]] { get }
}


let dummyToDos: [ToDo] = [
    ToDo(title: "투두 제목 1", description: "asdf", date: 1234),
    ToDo(title: "투두 제목 2", description: "asdf", date: 1234),
    ToDo(title: "투두 제목 3", description: "asdf", date: 1234)
]
let dummyToDos2: [ToDo] = [
    ToDo(title: "두잉 제목 1", description: "asdf", date: 1234, status: .doing),
    ToDo(title: "두잉 제목 2", description: "asdf", date: 1234, status: .doing),
    ToDo(title: "두잉 제목 3", description: "asdf", date: 1234, status: .doing)
]
let dummyToDos3: [ToDo] = [
    ToDo(title: "돈 제목 1", description: "asdf", date: 1234, status: .done),
    ToDo(title: "돈 제목 2", description: "asdf", date: 1234, status: .done),
    ToDo(title: "돈 제목 3", description: "asdf", date: 1234, status: .done)
]

final class ToDoViewModel: ToDoViewModelOutput, ObservableObject {
    @Published
    var toDos: [[ToDo]] = [dummyToDos,dummyToDos2,dummyToDos3]
    
    
    func selectSpecificList(by state: ToDoStatus) -> [ToDo] {
        return toDos[state.indexValue]
    }
    
    private func findToDo(_ toDo: ToDo) -> Int? {
        for index in 0..<toDos[toDo.status.indexValue].count {
            if toDos[toDo.status.indexValue][index].id == toDo.id {
                return index
            }
        }
        return nil
    }
}

extension ToDoViewModel: ToDoViewModelInput {
    func addToDo(_ toDo: ToDo) {
        toDos[toDo.status.indexValue].append(toDo)
    }
    
    func deleteToDo(_ toDo: ToDo) {
        guard let targetIndex = findToDo(toDo) else {
            return
        }
        toDos[toDo.status.indexValue].remove(at: targetIndex)
    }
    
    func editToDo(_ toDo: ToDo) {
        guard let targetIndex = findToDo(toDo) else {
            return
        }
        toDos[toDo.status.indexValue][targetIndex] = toDo
    }
    
    func moveColumn(toDo: ToDo, to state: ToDoStatus) {
        let newToDo = ToDo(id: toDo.id, title: toDo.title, description: toDo.description, date: toDo.date, status: state)
        deleteToDo(toDo)
        addToDo(newToDo)
    }
}
