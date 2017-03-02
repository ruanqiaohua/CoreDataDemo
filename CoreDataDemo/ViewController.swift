//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by 阮巧华 on 2017/3/2.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var people = [NSManagedObject]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CellIndentifier")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let content = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        do {
            let fetchedEntities = try content.fetch(request)
            self.people = fetchedEntities as! [NSManagedObject];
        } catch {
            print(error)
        }
    }
    // 增加
    @IBAction func addBtnAction(_ sender: UIBarButtonItem) {
        
        let content = CoreDataManager.sharedInstance.persistentContainer.viewContext

        let entity =  NSEntityDescription.entity(forEntityName: "Person",in:content)

        let person = NSManagedObject(entity: entity!, insertInto: content)
        person.setValue("Hello World", forKey: "name")
        person.setValue(self.people.count, forKey: "indexPath")
        self.people.append(person)
        self.tableView.reloadData()
    }
    // 垃圾桶
    @IBAction func trashBtnAction(_ sender: UIBarButtonItem) {
        
        guard self.people.count > 0 else {
            return
        }
        self.people.removeLast()
        self.tableView.reloadData()
        
        let content = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.predicate = NSPredicate(format: "indexPath == %d", self.people.count)
        do {
            let fetchedEntities = try content.fetch(request)
            guard fetchedEntities.count > 0 else {
                return
            }
            content.delete(fetchedEntities.last as! NSManagedObject)
        } catch {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIndentifier")!
        let person = people[indexPath.row]
        cell.textLabel!.text = person.value(forKey: "name") as! String?
        return cell
    }
}

