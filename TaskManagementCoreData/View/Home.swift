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
                
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("Color1").opacity(0.7), in: Circle())
            })
            .padding()
            ,alignment: .bottomTrailing
        )
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
        HStack(alignment: .top, spacing: 30) {
            VStack(spacing: 10) {
                Text("\(task.taskDate?.formatted(date: .omitted, time: .shortened) ?? "")")
                    .font(.callout)
                    .bold()
                    .frame(width: 60)
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
                    HStack(spacing: 0) {
                        HStack(spacing: -10) {
                            ForEach(["User1", "User2", "User3"], id: \.self) { user in
                                Image(user)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .background(
                                        Circle()
                                            .stroke(.white, lineWidth: 5)
                                    )
                            }
                        }
                        .hLeading()
                        
                        //MARK: - Check Button
                        Button {
                            
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color("Orange"))
                                .padding(5)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        }
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
            
            Button {
                
            } label: {
                Image("Profile")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            }
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
