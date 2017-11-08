//
//  HomeViewController.swift
//  TodoApp
//
//  Created by Best Peers on 07/11/17.
//  Copyright © 2017 Best Peers. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {
    var selectedTask:Task?
    var selectedSort:String = "Date"
    var todoList = Array<Task>()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var sortButton: UIButton!
    
    // MARK: View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        fetchTodoList()
        reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let item = todoList[indexPath.row]
        cell.textLabel?.text = item.title
        cell.textLabel?.alpha = item.completed ? 0.5 : 1
        cell.detailTextLabel?.text = getTextToDisplayFormattingDate(date: item.startDate)
        cell.priorityButton.tag = indexPath.row
        cell.priorityButton.addTarget(self, action: #selector(self.priorityButtonTapped(sender:)), for: .touchUpInside);
        cell.priorityButton.setTitle(item.priority == 1 ? "!" : item.priority == 2 ? "!!" : "!!!" , for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = todoList[indexPath.row]
            try! realmInstance.write({
                realmInstance.delete(item)
                todoList.remove(at: indexPath.row)
                self.tableView.deleteRows(at:[indexPath], with: .automatic)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = todoList[indexPath.row]
        modify(task: item)
    }

    // MARK: Private Methods
    
    func initialSetup() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        searchTextField.addTarget(self, action:  #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    func fetchTodoList(title:String = ""){
        var items:Results<Task>?
        if title.characters.count > 0 {
            items = realmInstance.objects(Task.self).filter("title contains[c] '\(title)'")
        }
        else{
            items = realmInstance.objects(Task.self)
        }
        
        todoList = []
        for item in items!{
            todoList.append(item)
        }
        
        reloadData()
    }
    
    @objc func add() {
        let alertController = UIAlertController(title: "New Task", message: "Enter Task Name", preferredStyle: .alert)
        var alertTextField: UITextField!
        alertController.addTextField { textField in
            alertTextField = textField
            textField.placeholder = "Task Name"
        }
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            guard let text = alertTextField.text , !text.isEmpty else { return }
            
            let task = Task()
            task.title = alertTextField.text!
            self.todoList.append(task)
            
            try! realmInstance.write {
                realmInstance.add(task)
            }
            self.reloadData()
        })
        present(alertController, animated: true, completion: nil)
    }
    
    func modify(task:Task) {
        let alertController = UIAlertController(title: "Change Task", message: "New Task Name", preferredStyle: .alert)
        var alertTextField: UITextField!
        alertController.addTextField { textField in
            alertTextField = textField
            textField.placeholder = task.title
        }
        alertController.addAction(UIAlertAction(title: "Update", style: .default) { _ in
            guard let text = alertTextField.text , !text.isEmpty else { return }
            
            try! realmInstance.write {
                task.title = alertTextField.text!
            }
            self.reloadData()
        })
        present(alertController, animated: true, completion: nil)
    }
    
    func getTextToDisplayFormattingDate(date: Date) -> String {
        var textToDisplay = ""
        
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        if timeInterval < 60 {
            textToDisplay = "just now "
        }
        else if timeInterval < 60 * 60 {
            textToDisplay = "\(Int(timeInterval / 60))"
            if Int(timeInterval / 60) == 1 {
                textToDisplay = textToDisplay + " min"
            } else {
                textToDisplay = textToDisplay + " mins"
            }
        }
        else if timeInterval < 60 * 60 * 24 {
            textToDisplay = "\(Int(timeInterval / 60 / 60))"
            if Int(timeInterval / 60 / 60) == 1 {
                textToDisplay = textToDisplay + " hour"
            } else {
                textToDisplay = textToDisplay + " hours"
            }
        }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            
            if timeInterval < 60 * 60 * 24 * 6 { //less than 6 days
                // For getting days
                // textToDisplay = "\(Int(timeInterval / 60 / 60 / 24)) d"
                
                // For getting weekday name
                dateFormatter.dateFormat = "EEEE"
                textToDisplay = dateFormatter.string(from: date) //weekday name
            }
            else{
                dateFormatter.dateFormat = "MMM dd"
                textToDisplay = dateFormatter.string(from: date as Date)
            }
        }
        
        return textToDisplay
    }
    
    func updatePriority(action: UIAlertAction) {
        var priority = 1
        switch action.title! {
        case "Normal":
            priority = 2
        case "High":
            priority = 3
        default:
            priority = 1
        }
        
        try! realmInstance.write {
            selectedTask?.priority = priority
        }
        reloadData()
    }
    
    func reloadData(){
       sort()
        self.tableView.reloadData()
        
    }
    
    func applySort(action: UIAlertAction) {
        selectedSort = action.title!
        self.sortButton.setTitle(selectedSort, for: .normal)
        reloadData()
    }
    
    func sort() {
        if todoList.count > 0 {
            switch selectedSort {
            case "Date":
                self.todoList.sort { $0.startDate < $1.startDate }
            case "Priority":
                self.todoList.sort {
                    if $0.priority == $1.priority{
                        return $0.startDate < $1.startDate
                    }
                    else
                    {
                        return $0.priority > $1.priority
                    }
                    
                }
            default:
                self.todoList.sort {
                    if $0.title == $1.title{
                        return $0.startDate < $1.startDate
                    }
                    else
                    {
                        return $0.title < $1.title
                    }
                    
                }
            }
        }
    }
    
    // MARK: UITextField
    
    @objc func textFieldDidChange(textField: UITextField) {
        fetchTodoList(title: textField.text!)
    }
    
    //MARK: - IBActions
    @IBAction func sortyByButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Sort By", message: "", preferredStyle: .actionSheet)
        
        for i in ["Date", "Priority", "Name"] {
            alert.addAction(UIAlertAction(title: i, style: .default, handler: applySort))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func priorityButtonTapped(sender : UIButton){
        selectedTask = todoList[sender.tag]
        let alert = UIAlertController(title: "Select Priority", message: "", preferredStyle: .actionSheet)
        
        for i in ["Low", "Normal", "High"] {
            alert.addAction(UIAlertAction(title: i, style: .default, handler: updatePriority))
        }
        self.present(alert, animated: true, completion: nil)
    }
}

