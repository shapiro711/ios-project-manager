//
//  ToDoPopover.swift
//  ProjectManager
//
//  Created by Kim Do hyung on 2021/11/03.
//

import SwiftUI

struct ToDoPopover: View {
    let column: Int
    let row: Int
    @Binding var isPopoverShown: Bool
    @EnvironmentObject var toDoViewModel: ToDoViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            Button {
                toDoViewModel.move(oldColumn: column, oldRow: row, to: (column + 1) % 3)
                isPopoverShown = false
            } label: {
                Text("Move to \(toDoViewModel.toDoModel.toDoType[(column + 1) % 3].rawValue)")
                    .font(.title3)
            }
            .padding()
            .background(Color.white)

            Button {
                toDoViewModel.move(oldColumn: column, oldRow: row, to: (column + 2) % 3)
                isPopoverShown = false
            } label: {
                Text("Move to \(toDoViewModel.toDoModel.toDoType[(column + 2) % 3].rawValue)")
                    .font(.title3)
            }
            .padding()
            .background(Color.white)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
    }
}

struct ToDoPopover_Previews: PreviewProvider {
    static var previews: some View {
        ToDoPopover(column: 0, row: 0, isPopoverShown: .constant(true))
    }
}
