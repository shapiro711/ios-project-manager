//
//  ToDoList.swift
//  ProjectManager
//
//  Created by JINHONG AN on 2021/10/28.
//

import SwiftUI

struct ToDoList: View {
    let column: Int
    @Binding var isDetailViewPresented: Bool
    @EnvironmentObject var toDoViewModel: ToDoViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            ToDoHeader(headerTitle: toDoViewModel.toDoModel.toDoType[column].rawValue, rowCount: toDoViewModel.toDoModel.toDos[column].count.description)
            
            List {
                ForEach(Array(toDoViewModel.toDoModel.toDos[column].enumerated()), id: \.element.id) { index, toDo in
                    ToDoRow(column: column, row: index, toDo: toDo)
                        .onTapGesture {
                            isDetailViewPresented = true
                        }
                }
                .onDelete { indexSet in
                    toDoViewModel.delete(column: column, indexSet: indexSet)
                }
            }
            .listStyle(.plain)
            .background(Color(UIColor.systemGray6))
        }
    }
}

struct ToDoList_Previews: PreviewProvider {
    static var previews: some View {
        ToDoList(column: 0, isDetailViewPresented: .constant(false))
    }
}
