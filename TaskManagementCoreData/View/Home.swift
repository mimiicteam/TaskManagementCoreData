//
//  Home.swift
//  TaskManagermentAppUI
//
//  Created by MINH DUC NGUYEN on 10/06/2022.
//

import SwiftUI

struct Home: View {
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    
    //MARK: - Core Data Context
    @Environment(\.managedObjectContext) var context
    //MARK: - Edit Button Context
    @Environment(\.editMode) var editButton
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            //MARK: - Lazy Stack With Pinned Header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    //MARK: - Current Week View
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(taskModel.currentWeek, id: \.self) {day in
                                VStack(spacing: 10) {
                                    //MARK: - EEE Will return day as Mon, Tue, Wed...
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                        .foregroundColor(taskModel.isToday(date: day) ? .white : .gray)
                                    
                                    //MARK: - EEE Will return day as 1, 2, 3...
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                        .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
                                //MARK: - Rounded Rectangle
                                .frame(width: 45, height: 70)
                                .background {
                                    ZStack {
                                        //MARK: - Matched Geomatry Effect
                                        if taskModel.isToday(date: day) {
                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(Color("Orange"))
                                                .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                }
                                .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .onTapGesture {
                                    withAnimation {
                                        //MARK: - Updating Current Day
                                        taskModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    TasksView()
                } header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        //MARK: - Add Button
        .overlay(
            Button(action: {
                taskModel.addNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("Color1").opacity(0.7), in: Circle())
            })
            .padding()
            ,alignment: .bottomTrailing
        )
        .sheet(isPresented: $taskModel.addNewTask) {
            // Clear Edit Data
            taskModel.editTask = nil
        } content: {
            NewTask()
                .environmentObject(taskModel)
        }
    }
    
    //MARK: - Tasks View
    @ViewBuilder
    func TasksView() -> some View {
        LazyVStack(spacing: 18) {
            // Converting object as Our Task Model
            DynamicFilteredView(dateToFilter: taskModel.currentDay) { (object: Task) in
                TaskCardView(task: object)
            }
        }
        .padding()
        .padding(.top)
    }
    
    //MARK: - Task Card View
    @ViewBuilder
    func TaskCardView(task: Task) -> some View {
        HStack(alignment: editButton?.wrappedValue == .active ? .center : .top, spacing: 30) {
            // If Edit mode enabled then showing Delete Button
            if editButton?.wrappedValue == .active {
                // Edit Button for Current and Future Tasks
                VStack(spacing: 10) {
                    if task.taskDate?.compare(Date()) == .orderedDescending || taskModel.isToday(date: task.taskDate ?? Date()) {
                        Button {
                            taskModel.editTask = task
                            taskModel.addNewTask.toggle()
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Button {
                        //MARK: - Deleting Task
                        context.delete(task)
                        
                        // Saving
                        try? context.save()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
            } else {
                VStack(spacing: 10) {
                    Text("\(task.taskDate?.formatted(date: .omitted, time: .shortened) ?? "")")
                        .font(.callout)
                        .bold()
                        .frame(width: 60)
                }
            }
            
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.taskTitle ?? "")
                            .font(.title2.bold())
                        
                        Text(task.taskDescription ?? "")
                            .font(.callout.bold())
                    }
                    .hLeading()
                    
                    VStack(spacing: 5) {
                        Circle()
                            .frame(width: 5, height: 5)
                        
                        Circle()
                            .frame(width: 5, height: 5)
                    }
                }
                
                if taskModel.isCurrentHour(date: task.taskDate ?? Date()) {
                    //MARK: - Team Member
                    HStack(spacing: 12) {
                        //MARK: - Check Button
                        if !task.isCompleted {
                            Button {
                                // MARK: Updating Task
                                task.isCompleted = true
                                
                                // Saving
                                try? context.save()
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Color("Orange"))
                                    .padding(5)
                                    .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        
                        Text(task.isCompleted ? "Marked as Completed" : "Mark Task as Completed")
                            .font(.system(size: task.isCompleted ? 14 : 16, weight: .light))
                            .foregroundColor(task.isCompleted ? .black : .white)
                            .hLeading()
                    }
                    .padding(.top)
                }
            }
            .foregroundColor(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? .white : .black)
            .padding()
//            .padding(.top, getSafeArea().top)
            .hLeading()
            .background(
                (taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? Color("Orange") : Color("Color2"))
                    .cornerRadius(25)
            )
        }
        .hLeading()
    }
    
    //MARK: - Header
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                
                Text("Today")
                    .font(.largeTitle.bold())
                    .foregroundColor(Color("Color1"))
                    .frame(width: 140, height: 60)
                    .background(Color("Color1").opacity(0.2))
                    .cornerRadius(8)
            }
            .hLeading()
            
//            Button {
//
//            } label: {
//                Image("Profile")
//                    .resizable()
//                    .frame(width: 45, height: 45)
//                    .aspectRatio(contentMode: .fill)
//                    .clipShape(Circle())
//            }
            
            //MARK: -  Edit Button
            EditButton()
        }
//        .cornerRadius(25)
        .padding(.vertical, 30)
        .padding()
        .background(.white)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

//MARK: - UI Design Helper functions
extension View {
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    //MARK: - Safe Area
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        return safeArea
    }
}
