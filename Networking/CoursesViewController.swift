//
//  CoursesViewController.swift
//  Networking
//
//  Created by Felix Falkovsky on 26.09.2020.
//

import UIKit

class CoursesViewController: UIViewController {
    
    private var courses = [Course]()
    private var courseName: String?
    private var courseURL: String?
    
    @IBOutlet var tabView: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
    }
    
    func fetchData() {
       // let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_course"
        let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
       // let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
       //   let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.courses = try decoder.decode([Course].self, from: data)
                DispatchQueue.main.async {
                    self.tabView.reloadInputViews()
                }
            } catch let error {
                print("*** ERROR JSON ***", error)
            }
        }.resume()
    }
    
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath) {
        let course = courses[indexPath.row]
        cell.courseNameLabel.text = course.name
        
        if let namberOfLessons = course.numberOfLessons {
            cell.numberOfLessons.text = "Number of Lessons \(namberOfLessons)"
        }
        
        if let numberOfTests = course.numberOfTests {
            cell.numberOfTests.text = "Number of Test \(numberOfTests)"
        }
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: course.imageUrl!) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                cell.courseImage.image = UIImage(data: imageData)
            }
        }
    }
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! WebViewController
        webViewController.selectedCourse = courseName
        if let url = courseURL {
            webViewController.courseURL = url
            
        }
    }
}

// MARK: Table View Data Source

extension CoursesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
}

 

// MARK: Table View Delegate

extension CoursesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]
        courseURL = course.link
        courseName = course.name
        
        performSegue(withIdentifier: "Description", sender: self)
    }
}


