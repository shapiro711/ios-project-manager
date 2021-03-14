//
//  ListItemDetailViewController.swift
//  ProjectManager
//
//  Created by sole on 2021/03/09.
//

import UIKit

class ListItemDetailViewController: UIViewController {
    private var statusType: ItemStatus = .todo
    private var detailViewType: DetailViewType = .create
    private var itemIndex: Int = 0
    private let descriptionTextViewTextMaxCount: Int = 1000
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Title"
        textField.borderStyle = .roundedRect
        textField.layer.shadowColor = UIColor.systemGray4.cgColor
        textField.layer.masksToBounds = false
        textField.layer.shadowOffset = CGSize(width: 5, height: 5)
        textField.layer.shadowRadius = 1
        textField.layer.shadowOpacity = 1
        return textField
    }()
    private let deadLineDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        return datePicker
    }()
    private let deadLineDatePickerEnableToggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("날짜 선택 안함", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "square.fill"), for: .selected)
        button.addTarget(self, action: #selector(touchUpCheckboxButton), for: .touchUpInside)
        return button
    }()
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = false
        textView.layer.shadowOffset = CGSize(width: 5, height: 5)
        textView.layer.shadowRadius = 1
        textView.layer.shadowOpacity = 1
        textView.layer.shadowColor = UIColor.systemGray4.cgColor
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateDelegate()
        setUpView()
        configureAutoLayout()
    }
    
    private func delegateDelegate() {
        descriptionTextView.delegate = self
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        view.addSubview(titleTextField)
        view.addSubview(deadLineDatePicker)
        view.addSubview(deadLineDatePickerEnableToggleButton)
        view.addSubview(descriptionTextView)
    }
    
    private func configureAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            titleTextField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            titleTextField.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.95),
            titleTextField.heightAnchor.constraint(equalToConstant: 80),
            
            deadLineDatePicker.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            deadLineDatePicker.centerXAnchor.constraint(equalTo: titleTextField.centerXAnchor),
            deadLineDatePicker.widthAnchor.constraint(equalTo: titleTextField.widthAnchor),
            
            deadLineDatePickerEnableToggleButton.topAnchor.constraint(equalTo: deadLineDatePicker.bottomAnchor, constant: 10),
            deadLineDatePickerEnableToggleButton.trailingAnchor.constraint(equalTo: deadLineDatePicker.trailingAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: deadLineDatePickerEnableToggleButton.bottomAnchor, constant: 10),
            descriptionTextView.centerXAnchor.constraint(equalTo: titleTextField.centerXAnchor),
            descriptionTextView.widthAnchor.constraint(equalTo: titleTextField.widthAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30)
        ])
    }
    
    func configureDetailView(itemStatus: ItemStatus, type: DetailViewType, index: Int = 0) {
        self.statusType = itemStatus
        self.detailViewType = type
        self.itemIndex = index
        configureNavigationBar()
        
        if type == .edit {
            let todo = ItemList.shared.getItem(statusType: itemStatus, index: index)
            fillContents(todo: todo)
        }
    }
    
    private func configureNavigationBar() {
        let leftBarButton: UIBarButtonItem = {
            let barButtonItem = UIBarButtonItem()
            barButtonItem.title = detailViewType.leftButtonName
            barButtonItem.style = .plain
            barButtonItem.target = self
            
            switch detailViewType {
            case .create:
                barButtonItem.action = #selector(edit)
            case .edit:
                barButtonItem.action = #selector(cancel)
                makeIneditable()
            }
            return barButtonItem
        }()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        
        navigationItem.title = statusType.title
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func makeIneditable() {
        titleTextField.isUserInteractionEnabled = false
        descriptionTextView.isEditable = false
    }
    
    private func fillContents(todo: Todo) {
        titleTextField.text = todo.title
        descriptionTextView.text = todo.description
        
        if let deadline = todo.deadLine {
            deadLineDatePicker.date = deadline
        } else {
            deadLineDatePickerEnableToggleButton.isSelected.toggle()
            deadLineDatePicker.isEnabled.toggle()
        }
    }
    
    @objc private func touchUpCheckboxButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        deadLineDatePicker.isEnabled.toggle()
    }
    
    @objc func edit() {
        titleTextField.isUserInteractionEnabled = true
        descriptionTextView.isEditable = true
    }
    
    @objc func cancel() {
        
    }
    
    @objc func done() {
        
    }
}

extension ListItemDetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textViewText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let TextMaxCount = textViewText.count
        return TextMaxCount <= descriptionTextViewTextMaxCount
    }
}
