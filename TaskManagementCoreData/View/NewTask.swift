//
//  NewTask.swift
//  TaskManagementCoreData
//
//  Created by MINH DUC NGUYEN on 19/06/2022.
//

import SwiftUI

struct NewTask: View {
    @Environment(\.dismiss) var dismiss
    
    //MARK: - Task Values
    @State var taskTitle: String = ""
    @State var taskDescription: String = ""
    @State var taskDate: Date = Date()
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Go to work", text: $taskTitle)
                } header: {
                    Text("Task Title")
                }
                
                Section {
                    TextField("Nothing", text: $taskDescription)
                } header: {
                    Text("Task Description")
                }
                
                Section {
                    DatePicker("", selection: $taskDate)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                } header: {
                    Text("Task Date")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Add New Task")
            .navigationBarTitleDisplayMode(.inline)
            //MARK: - Disbaling Dismiss on Swipe
            .interactiveDismissDisabled()
            //MARK: - Action Buttons
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Save") {
                        
                    }
                    .disabled(taskTitle == "" || taskDescription == "")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
