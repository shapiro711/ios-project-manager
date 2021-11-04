//
//  ToDo.swift
//  ProjectManager
//
//  Created by JINHONG AN on 2021/10/28.
//

import Foundation

enum ToDoStatus: String {
    case toDo = "ToDo"
    case doing = "Doing"
    case done = "Done"
}

struct ToDo: Identifiable {
    var id = UUID()
    var title: String = ""
    var description: String = ""
    var date: Date = Date()
    var status: ToDoStatus = .toDo
}


