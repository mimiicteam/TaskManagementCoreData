//
//  DynamicFilteredView.swift
//  TaskManagementCoreData
//
//  Created by MINH DUC NGUYEN on 19/06/2022.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View, T>: View where T: NSManagedObject{
    //MARK: - Core Data Request
    @FetchRequest var request: FetchedResults<T>
    let content: (T) -> Content
    
    //MARK: - Building Custom ForEach which will give CoreData object to build View
    init(dateToFilter: Date, @ViewBuilder content: @escaping (T) -> Content) {
        //MARK: - Predicate to Filter current date Task
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: dateToFilter)
        let tommorow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        // Filter Key
        let filterKey = "taskDate"
        
        // This will fetch task between today and tommorow which is 24 hours
        let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today, tommorow])
        
        // Intializing Request With NSPredicate
        // Adding Sort
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.taskDate, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    
    var body: some View {
        Group {
            if request.isEmpty {
                Text("No tasks found!!!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id: \.objectID) { object in
                    self.content(object)
                }
            }
        }
    }
}
