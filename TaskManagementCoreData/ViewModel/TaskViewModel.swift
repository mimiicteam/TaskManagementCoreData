//
//  TaskViewModel.swift
//  TaskManagermentAppUI
//
//  Created by MINH DUC NGUYEN on 10/06/2022.
//

import SwiftUI
class TaskViewModel: ObservableObject {
    //MARK: - Current Week Days
    @Published var currentWeek: [Date] = []
    
    //MARK: - Current Day
    @Published var currentDay: Date = Date()
    
    //MARK: - Filtering Today Tasks
    @Published var filteredTask: [Task]?
    
    //MARK: - Intializing
    init() {
        fetchCurrentWeek()
    }
    
    
    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeedDay = week?.start else {
            return
        }
        
        (0...6).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeedDay) {
                currentWeek.append(weekday)
            }
        }
    }
    
    //MARK: - Extracting Date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    //MARK: - Checking If current Date is Today
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    //MARK: - Checking if the currentHour is task Hour
    func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        return hour == currentHour
    }
}
