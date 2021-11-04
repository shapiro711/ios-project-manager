//
//  ToDoDetail.swift
//  ProjectManager
//
//  Created by JINHONG AN on 2021/10/28.
//

import SwiftUI

struct ToDoDetail: View {
    @EnvironmentObject var toDoViewModel: ToDoViewModel
    @State var toDo = ToDo()
    @Binding var isDetailViewPresented: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    
                } label: {
                    Text("Edit")
                }
                Spacer()
                Text("TODO")
                Spacer()
                Button {
                    toDoViewModel.add(toDo)
                    isDetailViewPresented = false
                } label: {
                    Text("Done")
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            VStack {
                TextField("Title", text: $toDo.title)
                    .padding()
                    .background(Color.white.shadow(color: .gray, radius: 3, x: 1, y: 4))
                DatePicker(selection: $toDo.date, label: {})
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                TextEditor(text: $toDo.description)
                    .background(Color.white.shadow(color: .gray, radius: 3, x: 1, y: 4))
            }
            .padding()
        }
    }
}

struct ToDoDetail_Previews: PreviewProvider {
    static var previews: some View {
        ToDoDetail(isDetailViewPresented: .constant(true))
    }
}
