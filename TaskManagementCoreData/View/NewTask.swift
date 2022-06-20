//
//  NewTask.swift
//  TaskManagementCoreData
//
//  Created by MINH DUC NGUYEN on 19/06/2022.
//

import SwiftUI

struct NewTask: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            List {
                
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
