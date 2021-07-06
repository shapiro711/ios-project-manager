//
//  DetailViewController.swift
//  ProjectManager
//
//  Created by 강경 on 2021/06/29.
//

import UIKit

final class DetailViewController: UIViewController {
    private let dateConverter = DateConverter()
    private var viewStyle: DetailViewStyle = .add
    private var viewModel = DetailViewModel()
    private var itemIndex: Int = 0
    
    @IBOutlet weak var newTitle: UITextField!
    @IBOutlet weak var newDate: UIDatePicker!
    @IBOutlet weak var newContent: UITextView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    @IBAction func clickDoneButton(_ sender: Any) {
        switch viewStyle {
        case .add:
            complete() { (newCell: TableItem) in
                viewModel.insert(cell: newCell)
            }
        case .edit:
            complete() { (newCell: TableItem) in
                viewModel.edit(
                    cell: newCell,
                    at: itemIndex
                )
            }
        }
    }
    
    @IBAction func clickLeftButton(_ sender: Any) {
        switch viewStyle {
        case .add:
            cancelView()
        case .edit:
            makeTodoListItemEditable()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(
            name: Notification.Name(Strings.dismissDetailViewNotification),
            object: nil,
            userInfo: nil
        )
    }
    
    func updateUI() {
        if let item = viewModel.tableItem() {
            newTitle.text = item.title
            newDate.date = dateConverter.numberToDate(number: item.date)
            newContent.text = item.summary
        }
        
        if viewStyle == .edit {
            setEditView()
        }
    }
    
    func changeToEditMode() {
        viewStyle = .edit
    }
    
    func setViewModel(
        tableViewModel: TodoTableViewModel,
        index: Int
    ) {
        itemIndex = index
        
        let newItem = tableViewModel.itemInfo(at: index)
        viewModel.setItem(newItem)
    }
    
    private func setEditView() {
        leftButton.setTitle(
            Strings.editStyleTitle,
            for: UIControl.State.normal
        )
        
        rightButton.isEnabled = false
        newTitle.isEnabled = false
        newDate.isEnabled = false
        newContent.isEditable = false
    }
}

// MARK: - Button Action
extension DetailViewController {
    private func complete(_ save: (_ newCell: TableItem) -> Void) {
        let title: String = newTitle.text!
        let date: Double = dateConverter.dateToNumber(date: newDate.date)
        let content: String = newContent.text
        
        let newCell = TableItem(
            title: title,
            summary: content,
            date: date
        )
        save(newCell)
        
        NotificationCenter.default.post(
            name: Notification.Name(Strings.dismissDetailViewNotification),
            object: nil,
            userInfo: nil
        )
        
        dismiss(
            animated: true,
            completion: nil
        )
    }
    
    private func makeTodoListItemEditable() {
        rightButton.isEnabled = true
        newTitle.isEnabled = true
        newDate.isEnabled = true
        newContent.isEditable = true
    }
    
    private func cancelView() {
        dismiss(
            animated: true,
            completion: nil
        )
    }
}
