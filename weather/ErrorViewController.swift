//
//  ErrorViewController.swift
//  weather
//
//  Created by Susom Shrestha on 2023-04-21.
//

import UIKit
import CoreData

class ErrorViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!;
    
    var errors: [ErrorItem] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self;
        // Do any additional setup after loading the view.
        
        loadDefaultItems();
    }
    
    func getCoreContext() -> NSManagedObjectContext? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }

    
    @IBAction func onDeletePressed(_ sender: UIBarButtonItem) {
        guard let context = getCoreContext() else {
            return;
        }
        
        for error in errors {
            context.delete(error)
        }
        do {
            try context.save();
        } catch {
            print(error);
        }
        
        errors = [];
        
        tableView.reloadData()
    }
    
    @IBAction func onDonePressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func getIcon(code: Int) -> UIImage? {
        var iconName = ""
        switch code {
        case 1006:
            iconName = "key";
            break;
        case 2008:
            iconName = "location.magnifyingglass";
            break;
        default:
            iconName = "x.circle";
        }
        return UIImage(systemName: iconName) ?? nil;
    }
    
    func loadDefaultItems() {
        guard let context = getCoreContext() else {
            return;
        }
        
        let request = ErrorItem.fetchRequest();
        
        do {
            
            try errors = context.fetch(request)
        } catch {
            print(error)
        }
    }
    
}

extension ErrorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return errors.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationItemCell");
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "errorCell", for: indexPath);
        let item = errors[indexPath.row];
        
        var content = cell.defaultContentConfiguration();
        content.text = "Code: \(item.code)";
        content.secondaryText = item.message;
        content.image = getIcon(code: Int(item.code));
        
        cell.contentConfiguration = content;
        
        return cell;
    }
}

struct ErrorRes: Codable {
    var error: ErrorResItem;
}

struct ErrorResItem: Codable {
    var code: Int;
    var message: String;
}
